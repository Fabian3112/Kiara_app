//
//  CameraView.swift
//  Kiara
//
//  Created by Fabian Sand on 19.10.23.
//

import SwiftUI
import AVFoundation

struct CameraView<videoInput: CameraManagerInterface>: View {
    @Binding var isPresented: Bool
    @State var showResultView = false
    
    @State var degrees = 180.0
    @State var isRecording = false
    @State var start_time = DispatchTime.now()
    @State var selected_angles = [false,false,false,false,false,false,false,false,false]
    @State var show_menu = false
    @State var show_2D_Skeleton = false
    @State var show_3D_Skeleton = false
    
    @State var show_message = true
    
    @StateObject var mytimer = MyTimer()
    @StateObject var cameraManager:videoInput
    //@StateObject var videoPlayer = VideoPlayback()
    
    //    let posePrediction = PosePrediction()
    //    let yoloPrediction = Yolo_prediction()
    let predictions : Predictions
    let developerMode : Bool
    
    let train_evaluator : TrainEvaluator
    
    private let waitTime = 3//10
    var body: some View {
        
        
        //  NavigationView {
        VStack() {
            
            Text("time " + String(mytimer.getTimeSec()) )
            
            //Spacer()
            if developerMode {
                if !show_menu{
                    VStack{
                        Button{
                            show_menu = true
                        }label: {
                            Image(systemName: "menubar.arrow.down.rectangle").frame(width: 300,height: 30)
                                .font(.system(size: 40))
                        }.foregroundColor(.white).blueButtonBarStyle()
                        //Spacer()
                    }
                }
                else {
                    VStack{
                        Button{
                            show_menu = false
                        }label: {
                            Image(systemName: "menubar.arrow.up.rectangle").frame(width: 300,height: 30)
                                .font(.system(size: 40))
                        }.foregroundColor(.white).blueButtonBarStyle()
                        List {
                            Toggle("show 2D Skeleton",isOn: $show_2D_Skeleton)
                            Toggle("show 3D Skeleton",isOn: $show_3D_Skeleton)
                            Toggle("show evaluator",isOn: $show_message)
                            
                            ForEach((0...(Predictions.angles_to_calculate.count-1)), id: \.self) {
                                
                                Toggle(Predictions.joint_names_36m[Predictions.angles_to_calculate[($0)].0],isOn: $selected_angles[$0] )
                            }
                        }
                    }
                }
                Spacer()
            }else{
                Spacer()
            }
            
            if (mytimer.getWorkTimeSec() < waitTime){
               
                self.predict().overlay(VStack(){
                    Text("Get in Position")
                    Text("Start in " + String(waitTime - mytimer.getWorkTimeSec()) )
                }.foregroundColor(.white).font(.system(size: 40)).background(Color.blue).opacity(0.8).padding(6).cornerRadius(10)  )
                
            }else{
                
                if(self.show_message){
                    self.predict().overlay(
                        VStack{
                            Spacer()
                            train_evaluator.evaluate(angles: predictions.storedAnglePredictions.last)
                                .foregroundColor(.white).font(.system(size: 40)).background(Color.blue).opacity(0.8).padding(6).cornerRadius(10)
                        })
                }else{
                    self.predict()
                }
            }
            
            /*self.getImage(depthdata:true)?
                .resizable()
                .scaledToFit()*/ // TODO Depth Data Image removed
            
            if(show_3D_Skeleton) {
                
                Spacer()
                Slider(
                    value: $degrees,
                    in: 0...360,
                    step: 1
                ) {
                    Text("Rotation")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("360")
                }
            }
            /*Button{
                        degrees = degrees + 5
                    } label: {
                        Text("rotated by : " + degrees.description)
                    }*/
            //HStack{
            //    Toggle("Knee & ellbow Angle", isOn: $developerMode)
            //    Toggle("Hip & shoulder Mode", isOn: $developerMode)
            //}
            Spacer()
            CameraTabBarView(isPresented: $isPresented,isRecording: $isRecording, showResultView: $showResultView, mytimer : mytimer, cameraManager: cameraManager)
                .fullScreenCover(isPresented: $showResultView, content: {
                    ResultView(isPresented: $showResultView, stored3DPredictions: predictions.stored3DPredictions, storedAnglePredictions: predictions.storedAnglePredictions)
                })
            //  }.navigationTitle("Kiara")	.navigationBarTitleDisplayMode(.inline)
        }//.onAppear(perform: cameraManager.startRecording)
    }
    
    func getImage(depthdata : Bool = false) -> Image?{
        

        
        let ciContext = CIContext()
        let viedeoBuffer = cameraManager.videoPixelBuffer //if (depthdata) {cameraManager.depthData?.depthDataMap } else {videoPlayer.videoPixelBuffer}
        
        guard viedeoBuffer != nil else{ return nil}
        let ciimg = CIImage(cvPixelBuffer: viedeoBuffer!)
        let rot_ciimg = ciimg.oriented(.right)
        if let cgimg = ciContext.createCGImage(rot_ciimg, from: rot_ciimg.extent){
            
            // convert that to a UIImage
            let uiImage = UIImage(cgImage: cgimg)
            
            // and convert that to a SwiftUI image
            return Image(uiImage: uiImage)
        }else{
            return nil
        }
    }
    
    func predict() -> AnyView{
        
        if (mytimer.getWorkTimeSec() >= 60){
            print(predictions.storedAnglePredictions.count)
        }
        
        guard let image = cameraManager.videoPixelBuffer else {
            return (AnyView)(Text("No Image to Predict on"))
            
        }
        
        
        return predictions.predict(image: image, rotate: !developerMode, savePrediction: !(mytimer.getWorkTimeSec() < waitTime) && isRecording , degrees: Int(degrees) - 180, selected_angles:selected_angles,show_2D_Skeleton:show_2D_Skeleton,show_3D_Skeleton: show_3D_Skeleton)
        
    }
}
        
//        CVPixelBufferLockBaseAddress(image, .readOnly)
        
//        guard let poseNetOutput = posePrediction.predict(image:image)else{
//                return (AnyView)(Text("Error in Posenet Prediction"))
//        }
        
        //guard let yoloOutput = yoloPrediction.predict(image:image)else{
        //        return (AnyView)(Text("Error in Yolo Prediction"))
        //}
        //TODO Remove later ------------
//        guard let image = PosePrediction.resizePixelBuffer(image, width: 960, height: 960) else {
//                print("too bad")
//                fatalError("Unexpected runtime error. while resizing image")
//        }
        //---------------------------
//        let yoloPoints = yoloOutput.var_10
//        
//        let ciContext = CIContext()
//        var ciimg = CIImage(cvPixelBuffer: image)
//        ciimg = ciimg.oriented(.rightMirrored)
//       
//        guard let cgimg = ciContext.createCGImage(ciimg, from: ciimg.extent) else {
//            CVPixelBufferUnlockBaseAddress(image, .readOnly)
//            return (AnyView)(Text("Error Drawing in Image"))}
//        
//        let dstImageSize = CGSize(width: cgimg.width, height:cgimg.height)
//        let dstImageFormat = UIGraphicsImageRendererFormat()
//
//        
//        
//        
//        dstImageFormat.scale = 1
//        let renderer = UIGraphicsImageRenderer(size: dstImageSize,
//                                               format: dstImageFormat)
//        

        
//        guard let prediction = posePrediction.prediction else {
//            CVPixelBufferUnlockBaseAddress(image, .readOnly)
//            return (AnyView)(Text("Error Getting Prediction results"))}
//        let displacements = prediction.displacementBwdShapedArray
        
//        guard let poseNetOutput = posePrediction.poseNetOutput else {
//            fatalError("Failed to get the offsets MLMultiArray")
//        }
//        print(poseNetOutput.offsets)
        
        //print(poseNetOutput.position(for: Joint.Name.nose, at: PoseNetOutput.Cell(0, 0)))
        //print(poseNetOutput.position(for: Joint.Name.nose, at: PoseNetOutput.Cell(0, 1)))
        //print(poseNetOutput.position(for: Joint.Name.nose, at: PoseNetOutput.Cell(1, 0)))
        //print(poseNetOutput.position(for: Joint.Name.nose, at: PoseNetOutput.Cell(0, 15)))
        //print(poseNetOutput.position(for: Joint.Name.nose, at: PoseNetOutput.Cell(15, 0)))
        
        
        /*var max_val = 0.0
        var max_cell = PoseNetOutput.Cell(0,0)
        for x in 0...poseNetOutput.width{
            for y in 0...poseNetOutput.height{
                print(x.description + ":" + y.description + "-- off --" + poseNetOutput.width.description + ":" + poseNetOutput.height.description)
                let confidence = poseNetOutput.confidence(for: Joint.nose, at: PoseNetOutput.Cell(x,y))
                if confidence > max_val{
                    max_cell = PoseNetOutput.Cell(x,y)
                    max_val = confidence
                }
            }
        }
        
        print("confidence " + max_val.description + " at Position : " )
        print(poseNetOutput.position(for: Joint.nose, at: max_cell))
        let nose_Point = poseNetOutput.position(for: Joint.nose, at: max_cell)
        */
//        let joint_positions = poseNetOutput.one_person_joint_output()
//        accumulated2DPredictions.append(joint_positions)
        
//        let dstImage = renderer.image { rendererContext in
//            
//            let drawingRect = CGRect(x: 0, y: 0,width: cgimg.width, height: cgimg.height)
//            
//            let cgContext = rendererContext.cgContext
//            cgContext.draw(cgimg, in: drawingRect)
//            
//            /*cgContext.setFillColor(UIColor.red.cgColor)
//            cgContext.setStrokeColor(UIColor.green.cgColor)
//            cgContext.setLineWidth(10)
//            
//            let x = Double(cgimg.width) - nose_Point.y / 513.0 * Double(cgimg.width)
//            let y = nose_Point.x / 513.0 * Double(cgimg.height)
//            
//            let rectangle = CGRect(x: x-25, y: y-25, width: 50, height: 50)
//            cgContext.addEllipse(in: rectangle)
//            */
//            
//            for joint_position in poseNetOutput.one_person_joint_positions(imageWidth: cgimg.width, imageHeight: cgimg.height, 0.5){
//                cgContext.setFillColor(UIColor.yellow.cgColor)
//                cgContext.setStrokeColor(UIColor.yellow.cgColor)
//                
//                let rectangle = CGRect(x: joint_position.x-25, y: joint_position.y-25, width: 50, height: 50)
//                cgContext.addEllipse(in: rectangle)
//                
//            }
//            
//            cgContext.drawPath(using: .fillStroke)
//            
//            cgContext.setFillColor(UIColor.red.cgColor)
//            cgContext.setStrokeColor(UIColor.red.cgColor)
//            
//            for i in 0...16{
//                
//                print(yoloPoints[i*2].description + " : " + yoloPoints[i*2+1].description)
//                let rectangle = CGRect(x: yoloPoints[i*2].intValue-25,y: yoloPoints[i*2+1].intValue-25, width: 50, height: 50)
//                cgContext.addEllipse(in: rectangle)
//                
//            }
//            
//            cgContext.drawPath(using: .fillStroke)
//        }
        
//        CVPixelBufferUnlockBaseAddress(image, .readOnly)
//        return (AnyView)(Image(uiImage: dstImage)
//            .resizable()
//            .scaledToFit())
//    }
//}
/*
 #Preview {
     @State var isPresented = false
     CameraView(isPresented: $isPresented)
 }
 */
 
