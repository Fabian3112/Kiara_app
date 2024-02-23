//
//  CameraTabBar.swift
//  Kiara
//
//  Created by Fabian Sand on 19.12.23.
//
import SwiftUI

struct CameraTabBarView<videoInput:CameraManagerInterface>: View {
    
    //@State private var showScanView = false
    @Binding var isPresented: Bool
    @Binding var isRecording: Bool
    @Binding var showResultView: Bool
    //var stored3DPredictions : [[[Float]]]
    
    let mytimer : MyTimer
    
    var cameraManager: videoInput
    
    var body: some View {
        
        HStack(alignment: .bottom) {
            
            Spacer()
            
            
            TabBarItem(iconSystemName: "arrow.clockwise.circle.fill", tapped: $isPresented)
            
            Spacer()
            
            if(!isRecording){
                //Play
                    Button{
                        isRecording = true
                        cameraManager.startRecording()
                        mytimer.start()
                    }label: {
                        Image(systemName: "arrowtriangle.right.circle.fill")
                            .font(.system(size: 40))
                    }.foregroundColor(.white)
            }else{
                Button{
                    isRecording = false
                    cameraManager.pauseRecording()
                    mytimer.wait()
                }label: {
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 40))
                }.foregroundColor(.white)
                Spacer()
                //STOP
                Button{
                    isRecording = false
                    cameraManager.stopRecording()
                    mytimer.wait()
                    //isPresented = false
                    showResultView = true
                }label: {
                    Image(systemName: "square.circle.fill")
                        .font(.system(size: 40))
                }.foregroundColor(.white)
            }
            Spacer()/*.fullScreenCover(isPresented: $showResultView, content: {
                ResultView(isPresented: $showResultView, stored3DPredictions: stored3DPredictions)
            })*/
            
        }.blueButtonBarStyle()
    }
}
