//
//  Predictions.swift
//  Kiara
//
//  Created by Fabian Sand on 13.12.23.
//

import SwiftUI
import AVFoundation
import CoreML
import CoreGraphics

/*
Human 3.6M Points

(11) Head
(10) Nose
(15) Right Shoulder
(16) Right Elbow
(17) Right Wrist
(12) Left Shoulder
(13) Left Elbow
(14) Left Wrist
(1) Center Hip
(2) Right Hip
(3) Right Knee
(4) Right Ankle
(8) Throax
(5) Left Hip
(6) Left Knee
(7) Left Ankle
(9) Neck
*/

class Predictions {
    
    static let joint_names_36m: [String] = [
    "Center Hip",       //0
    "Right Hip",        //1
    "Right Knee",       //2
    "Right Ankle",      //3
    "Left Hip",         //4
    "Left Knee",        //5
    "Left Ankle",       //6
    "Throax",           //7
    "Neck",             //8
    "Nose",             //9
    "Head",             //10
    "Left Shoulder",    //11 //probably right not left
    "Left Elbow",       //12 //probably right not left
    "Left Wrist",       //13 //probably right not left
    "Right Shoulder",   //14 //probably left not right
    "Right Elbow",      //15 //probably left not right
    "Right Wrist"]      //16 //probably left not right
    
    static let joint_names: [String] = [
        "nose",         //0
        "left_eye",     //1
        "right_eye",    //2
        "left_ear",     //3
        "right_ear",    //4
        "left_shoulder",//5
        "right_shoulder",//6
        "left_elbow",   //7
        "right_elbow",  //8
        "left_wrist",   //9
        "right_wrist",  //10
        "left_hip",     //11
        "right_hip",    //12
        "left_knee",    //13
        "right_knee",   //14
        "left_ankle",   //15
        "right_ankle" ] //16
    
    static let angles_to_calculate:[(Int,Int,Int)] = [(15,14,16) /*right_elbow*/    ,  (12,11,13) /*left_elbow*/ ,
                                                      (5,4,6) /*right_knee*/        ,  (2,1,3) /*left_knee*/,
                                                      (1,2,11) /*right_hip*/        , (4,5,14)/*left_hip*/  , //(1,2,14) /*right_hip*/        , (4,5,11)/*left_hip*/ ,
                                                      //(14,15,1)  /*right_shoulder*/ , (11,12,4)/*left_shoulder*/,
                                                      (14,15,4)  /*right_shoulder*/ , (11,12,1)/*left_shoulder*/,
                                                      (0,2,5) /*knee hip knee*/]
    
    static let calculated_joint_angles_ids_coco : [Int] = [8,7,14,13,12,11,6,5,0/*TODO center Hip*/]
    
        
    static let limbs: [(Int, Int)] = [(15, 13), (13, 11), (16, 14), (14, 12), (11, 12), // lower body
                                (5, 11), (6, 12), (5, 6), (5, 7), (6, 8), (7, 9), (8, 10), // upper body
                                (1, 2), (0, 1), (0, 2), (1, 3), (2, 4), (3, 5), (4, 6)] // head
    
    
    static let limbs_36m: [(Int, Int)] = [(6, 5), (3, 2), (5, 4), (2, 1), (4, 0),(1,0), // lower body
                                //(4, 11), (1, 14), (11, 14), (11, 12), (14, 15), (12, 13), (15, 16), // upper body
                                  (4, 14), (1, 11), (11, 14), (11, 12), (14, 15), (12, 13), (15, 16), // upper body
                                  (7, 8), (8, 9), (9, 10)] // head
    
    //static let angles_to_calculate:[(Int,Int,Int)] = [(13,15,11),(14,16,12),(11,13,12),(12,14,11), //lower body
    //                                            (5,11,7),(6,12,8),(7,9,5),(8,10,6)] // upper body
    
    //let posePrediction = PosePrediction()
    let yoloPrediction = Yolo_prediction()
    let videoPose3d = PosePrediction3D()
    
    var stored3DPredictions = [[[Float]]]()
    
    var storedAnglePredictions = [[Int]]()
    var accumulated2DPredictions = [[[Double]]]()
    
    func predict(image :  CVPixelBuffer,rotate:Bool = false,savePrediction:Bool = true,degrees:Int = 0, selected_angles:[Bool],show_2D_Skeleton:Bool = true,show_3D_Skeleton: Bool = true)  -> AnyView {
        
        CVPixelBufferLockBaseAddress(image, .readOnly)
        let size = max ( CVPixelBufferGetWidth(image) , CVPixelBufferGetHeight(image))
        print(size)
        guard let image = PosePrediction.squarePixelBuffer(image, width: size, height: size,rotate: rotate ) else {
                print("too bad")
                fatalError("Unexpected runtime error. while resizing image")
        }
        /*
        guard let resizedImage = PosePrediction.resizePixelBuffer(image2, width: 513, height: 513) else {
            fatalError("Unexpected runtime error. while resizing image")
        }
        
        let ciContext = CIContext()
        var ciimg = CIImage(cvPixelBuffer: resizedImage)
        ciimg = ciimg.oriented(.left)
        
        guard let cgimg = ciContext.createCGImage(ciimg,from: ciimg.extent) else {
            fatalError("Unexpected runtime error. while resizing image")
        }
        // convert that to a UIImage
        let uiImage = UIImage(cgImage: cgimg)
        
        // and convert that to a SwiftUI image
        
        print(uiImage.size.width)
        print(uiImage.size.height)
        
        return (AnyView) (Image(uiImage: uiImage).scaledToFit())
        */
        
        //guard let poseNetOutput = posePrediction.predict(image:image) else{
        //        return (AnyView)(Text("Error in Posenet Prediction"))
        //}
        
//        TODO change resize
       
        
        
        //let poseNet_joints = poseNetOutput.one_person_joint_positions(imageWidth: 1920, imageHeight: 1920, confidence_threshhold: 0)
        
//        Prepare 2D Skeleton Output for 3D Lifiting
        //let joint_positions_output = poseNetOutput.one_person_joint_output()
        
        
        guard let yoloOutput = yoloPrediction.predict(image:image)else{
                return (AnyView)(Text("Error in Yolo Prediction"))
        }
        
        let yoloPoints = yoloOutput.var_1035
        
        let yolo_array = convertToArray(from: yoloPoints)
        
        var joint_positions :[(Int,Int)] = []
        var joint_probability :[Double] = []
        for i in 0...16 {
            joint_positions.append((Int(yolo_array[5 + i*3]), Int(yolo_array[6 + i*3])))
            joint_probability.append(yolo_array[7+i*3])
        }
        
        
        if(accumulated2DPredictions.count > 1){
            accumulated2DPredictions.removeFirst()
        }
        
        accumulated2DPredictions.append(normalize(output:joint_positions,size:640))
        
        if(accumulated2DPredictions.count < 27){
            print("filling predictions with frist prediction")
            while (accumulated2DPredictions.count < 27){
                accumulated2DPredictions.append(normalize(output:joint_positions,size:640))
            }
        }
        
//        TODO make 3D Prediction here
        
        guard let videoPrediction3d = videoPose3d.predict(input: accumulated2DPredictions) else{
                    return (AnyView)(Text("Error in 3d Prediction"))
        }
        
        let multArray = videoPrediction3d.var_142
        var prediction3d = [[Float]]()
        for i in 0...16{
            
            let x = multArray[[0 as NSNumber, 0 as NSNumber, i as NSNumber, 0 as NSNumber,]].floatValue
            let y = multArray[[0 as NSNumber, 0 as NSNumber, i as NSNumber, 1 as NSNumber,]].floatValue
            let z = multArray[[0 as NSNumber, 0 as NSNumber, i as NSNumber, 2 as NSNumber,]].floatValue
            
            prediction3d.append( [x,y,z] )
        }
        //for pred in prediction3d{
        //    print("(" + pred[0].description + "," + pred[1].description + "," + pred[2].description + ")")
        //}
        if(savePrediction){
            stored3DPredictions.append(prediction3d)
        }
        
        guard let resizedImage = PosePrediction.resizePixelBuffer(image, width: 640, height: 640) else {
            print("too bad")
                fatalError("Unexpected runtime error. while resizing image")
        }
        
        return drawImage(image: resizedImage, joints : joint_positions, probability: joint_probability,prediction3d: prediction3d,savePrediction: savePrediction,degrees:degrees, selected_angles: selected_angles,show_2D_Skeleton: show_2D_Skeleton, show_3D_Skeleton: show_3D_Skeleton)
    }
    
    private func calcAngele3D(connected_joint_3d:(Double,Double,Double),joint_2_3d:(Double,Double,Double),joint_3_3d:(Double,Double,Double)) -> Double{
        let v1 = (connected_joint_3d.0 - joint_2_3d.0, connected_joint_3d.1 - joint_2_3d.1,connected_joint_3d.2 - joint_2_3d.2)
        let v2 = (connected_joint_3d.0 - joint_3_3d.0, connected_joint_3d.1 - joint_3_3d.1,connected_joint_3d.2 - joint_3_3d.2)
        
        //normalize Vectors
        let v1mag = sqrt(v1.0 * v1.0 + v1.1 * v1.1 + v1.2 * v1.2)
        let v1norm = (v1.0 / v1mag, v1.1 / v1mag, v1.2 / v1mag)

        let v2mag = sqrt(v2.0 * v2.0 + v2.1 * v2.1 + v2.2 * v2.2)
        let v2norm = (v2.0 / v2mag, v2.1 / v2mag, v2.2 / v2mag)
        
        //dot product
        let res = v1norm.0 * v2norm.0 + v1norm.1 * v2norm.1 + v1norm.2 * v2norm.2
        return acos(res)
    }
    
    private func drawImage(image :  CVPixelBuffer, joints : [(Int,Int)] , probability: [Double], prediction3d: [[Float]] ,  treshhold :Double = 0.5, savePrediction:Bool, degrees:Int, selected_angles:[Bool],show_2D_Skeleton:Bool,show_3D_Skeleton: Bool) -> AnyView {//[CGPoint] ) {//, yolo_joints : MLMultiArray) -> AnyView {
        
        let ciContext = CIContext()
        var ciimg = CIImage(cvPixelBuffer: image)
        ciimg = ciimg.oriented(.down)// rotate Image
        
        let height = 640
        let width = 640
        guard let cgimg = ciContext.createCGImage(ciimg, from: ciimg.extent) else {
            CVPixelBufferUnlockBaseAddress(image, .readOnly)
            return (AnyView)(Text("Error Drawing in Image"))}
        
        let dstImageSize = CGSize(width: cgimg.width, height:cgimg.height)
        let dstImageFormat = UIGraphicsImageRendererFormat()
        
        dstImageFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: dstImageSize,
                                               format: dstImageFormat)
        
        
        let dstImage = renderer.image { rendererContext in
            
            let drawingRect = CGRect(x: 0, y: 0,width: cgimg.width, height: cgimg.height)
            
            let cgContext = rendererContext.cgContext
            
            
            cgContext.draw(cgimg, in: drawingRect)
            
            //Rotate before drawing the Predictions. Translate Rotate Translate back
            cgContext.translateBy(x: CGFloat(cgimg.width)/2.0, y: CGFloat(cgimg.height)/2.0)
            cgContext.rotate(by: Double.pi)
            cgContext.translateBy(x: -CGFloat(cgimg.width)/2.0, y: -CGFloat(cgimg.height)/2.0)
            
            var index = 0
            /*
            for joint_position in joints{
                if(probability[index] > treshhold){
//                    print("x : " + ( joint_position.0-25).description + "y " + (joint_position.1-25).description)
                    
                    cgContext.setFillColor(UIColor.yellow.cgColor)
                    cgContext.setStrokeColor(UIColor.yellow.cgColor)
                    
                    let rectangle = CGRect(x: joint_position.0-10, y: height - (joint_position.1-10), width: 20, height: 20)
                    cgContext.addEllipse(in: rectangle)
                }
                index += 1
            }
            cgContext.drawPath(using: .fillStroke)
            */
            cgContext.setStrokeColor(UIColor.white.cgColor)
            cgContext.setLineWidth(3)
            
            
            if show_2D_Skeleton{
                for limb in Predictions.limbs{
                    if(probability[limb.0] > treshhold && probability[limb.1] > treshhold){
                        cgContext.move(to: CGPoint(x: joints[limb.0].0, y: height - joints[limb.0].1))
                        cgContext.addLine(to: CGPoint(x: joints[limb.1].0, y: height - joints[limb.1].1))
                    }
                }
                cgContext.drawPath(using: .fillStroke)
            }
            
            index = 0
            var angle_predictions:[Int] = []
            
            cgContext.translateBy(x: CGFloat(cgimg.width)/2.0, y: CGFloat(cgimg.height)/2.0)
            cgContext.rotate(by: Double.pi)
            cgContext.translateBy(x: -CGFloat(cgimg.width)/2.0, y: -CGFloat(cgimg.height)/2.0)
            for positions in Predictions.angles_to_calculate {
                let joint_1 = (Double(prediction3d[positions.0][0]) ,Double(prediction3d[positions.0][1]) ,Double(prediction3d[positions.0][2]))
                let joint_2 = (Double(prediction3d[positions.1][0]) ,Double(prediction3d[positions.1][1]) ,Double(prediction3d[positions.1][2]))
                let joint_3 = (Double(prediction3d[positions.2][0]) ,Double(prediction3d[positions.2][1]) ,Double(prediction3d[positions.2][2]))
                let angle = Int(calcAngele3D(connected_joint_3d: joint_1, joint_2_3d: joint_2, joint_3_3d: joint_3) * 360 / (2*Double.pi))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 50)!, NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.foregroundColor : UIColor.red]
                
                let joint_id = Predictions.calculated_joint_angles_ids_coco[index]
                
                
                if selected_angles[index] {
                    angle.description.draw(with: CGRect(x: width - joints[joint_id].0, y: joints[joint_id].1, width: 100, height: 100),attributes: attrs,context: nil)
                }
                
                //print(Predictions.joint_names[positions.0] + " : " + angle.description)
                angle_predictions.append(angle)
                index += 1
            }
            cgContext.translateBy(x: CGFloat(cgimg.width)/2.0, y: CGFloat(cgimg.height)/2.0)
            cgContext.rotate(by: Double.pi)
            cgContext.translateBy(x: -CGFloat(cgimg.width)/2.0, y: -CGFloat(cgimg.height)/2.0)
            
            /*
             for positions in Predictions.angles_to_calculate{
                let joint_1 = (Double(prediction3d[positions.0][0]) ,Double(prediction3d[positions.0][1]) ,Double(prediction3d[positions.0][2]))
                let joint_2 = (Double(prediction3d[positions.1][0]) ,Double(prediction3d[positions.1][1]) ,Double(prediction3d[positions.1][2]))
                let joint_3 = (Double(prediction3d[positions.2][0]) ,Double(prediction3d[positions.2][1]) ,Double(prediction3d[positions.2][2]))
                let angle = Int(calcAngele3D(connected_joint_3d: joint_1, joint_2_3d: joint_2, joint_3_3d: joint_3) * 360 / (2*Double.pi))
                
                print(Predictions.joint_names[positions.0] + " : " + angle.description)
                angle_predictions.append(angle)
            }*/
            
            if savePrediction{
                storedAnglePredictions.append(angle_predictions)
            }
            
            cgContext.setFillColor(UIColor.red.cgColor)
            cgContext.setStrokeColor(UIColor.red.cgColor)
            cgContext.drawPath(using: .fillStroke)
            
            /*
            for i in 0...16{
                
                //print(i.description + " : " + yolo_joints[i*2].description + " : " + yolo_joints[i*2+1].description)
                let rectangle = CGRect(x: yolo_joints[i*2].intValue-25,y: yolo_joints[i*2+1].intValue-25, width: 50, height: 50)
                cgContext.addEllipse(in: rectangle)
                
            }
             
             print(cgimg.width)
             print(cgimg.height)
             */

            if show_3D_Skeleton {
                var points_3d_in_2d : [(Int,Int)] = []
                
                for point3D in prediction3d{
                    let rot_point3D :[Float] = rotate3DPoint(point3D,degrees:degrees)
                    
                    let distance = rot_point3D[2] + 1
                    if(distance != 0){
//                        let x2D_float = rot_point3D[0] * 250.0 / distance + 320.0
//                        let y2D_float =  rot_point3D[1] * 250.0 / distance + 160.0
                        let x2D_float = rot_point3D[0] * 250.0 / distance + 480.0
                        let y2D_float =  rot_point3D[1] * 250.0 / distance  + 320.0
                        let x2D = Int(x2D_float)
                        let y2D = Int(y2D_float)
                        print(x2D.description + " : " + y2D.description)
                        //let rectangle = CGRect(x: Int(x2D), y: height - (Int(y2D)), width: 20, height: 20)
                        //cgContext.addEllipse(in: rectangle)
                        points_3d_in_2d.append((x2D,height - y2D))
                    } else{
                        points_3d_in_2d.append((0,0))
                    }
                }
                
                for limb in Predictions.limbs_36m{
                    cgContext.move(to: CGPoint(x: points_3d_in_2d[limb.0].0, y: points_3d_in_2d[limb.0].1))
                    cgContext.addLine(to: CGPoint(x: points_3d_in_2d[limb.1].0, y: points_3d_in_2d[limb.1].1))
                    
                }
                
                
                cgContext.setFillColor(UIColor.blue.cgColor)
                cgContext.setStrokeColor(UIColor.blue.cgColor)
                cgContext.drawPath(using: .fillStroke)
            }
        }
        
        
        CVPixelBufferUnlockBaseAddress(image, .readOnly)
        return (AnyView)(Image(uiImage: dstImage)
            .resizable()
            .scaledToFit())
    }
    
    
    private func normalize(output:[(Int,Int)] , size:Int) -> [[Double]]{
        var normalized = [[Double]]()
        
        for i in 0...16 {
            let x = (Double(output[i].0) / Double(size)) * 2 - 1
            let y = (Double(output[i].1) / Double(size)) * 2 - 1
                                                    
            normalized.append([x ,y])
        }
        //print(normalized.description)
        return normalized
    }
    
    
    func convertToArray(from mlMultiArray: MLMultiArray) -> [Double] {
        
        // Init our output array
        var array: [Double] = []
        

        // Get length
        let length = mlMultiArray.shape[1]
        /*
        // Set content of multi array to our out put array
        var max_index = 0
        var max_val = 0.0
        for i in 0...(Int(truncating: length) - 1) {
            
            let val = Double( truncating: mlMultiArray[[NSNumber(value: 0),NSNumber(value: i),NSNumber(value: 4)]])
            if(val > max_val){
                max_index = i
                max_val = val
            }
            //array.append(Double(truncating: mlMultiArray[[0,NSNumber(value: i)]]))
        }
        
        print(max_val)
        print(max_index)
        */
        var max_index = 0
        var max_val = 0.0
        
        let length_2 = mlMultiArray.shape[2]
        for i in 0...(Int(truncating: length_2) - 1) {
            //print(mlMultiArray.shape.description + " [ 0, 4, " + i.description + " ]")
            let val = Double( truncating: mlMultiArray[[NSNumber(value: 0),NSNumber(value: 4),NSNumber(value: i)]])
            
            if(val > max_val){
                max_index = i
                max_val = val
            }
        }
        
        print(max_val)
        print(max_index)
        
        
        for i in 0...(Int(truncating: length) - 1) {
            let val = Double( truncating: mlMultiArray[[NSNumber(value: 0),NSNumber(value: i),NSNumber(value: max_index)]])
            array.append(val)
        }
        
        print(array.count)
        return array
    }
    
    func rotate3DPoint(_ points : [Float] , degrees: Int) -> [Float]{
        let x = points[0]
        let y = points[1]
        let z = points[2]
        
        
        let radians = Float(Double(degrees) / 360.0 * (2.0 * Double.pi))
        
        /*
         cosβ   0   sinβ
         0      1   0
         −sinβ  0   cosβ
         0
         
        */
        let result_x = x * cos(radians) + z * sin(radians)
        let result_y = y
        let result_z = -x * sin(radians) + z * cos(radians)
         
        
        /*
         cosγ   -sinγ    0
         sinγ   cosγ    0
         0      0       1
         
         
        let result_x = x * cos(radians) - y * sin(radians)
        let result_y = x * sin(radians) + y * cos(radians)
        let result_z = z
        */
        
        /*
         1  0   0
         0  cos -sin
         0  sin cos
         
        
        let result_x = x
        let result_y = y * cos(radians) - z * sin(radians)
        let result_z = y * sin(radians) + z * cos(radians)
        */
        
        return [result_x,result_y,result_z]
    }
}
