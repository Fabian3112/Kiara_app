//
//  PlayVideoView.swift
//  Kiara
//
//  Created by Fabian Sand on 19.12.23.
//

import SwiftUI

struct PlayVideoView : View {
    
    @Binding var isPresented: Bool
    @Binding var showCameraView: Bool
    
    let videoName :String
    
    
    var body: some View {
        VStack{
            Spacer()
            VideoPlayerRepresentable(videoName: videoName).scaledToFit()
            Spacer()
            VideoTabBarView(isPresented: $isPresented, showCameraView: $showCameraView)
        }
        
    }
}
