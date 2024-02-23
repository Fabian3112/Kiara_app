//
//  VideoPlayerRepresentable.swift
//  Kiara
//
//  Created by Fabian Sand on 19.12.23.
//

import SwiftUI

struct VideoPlayerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = VideoPlayer
    var videoName : String
    let videoPlayer :VideoPlayer
    
    init(videoName: String) {
        self.videoName = videoName
        self.videoPlayer = VideoPlayer(videoName:videoName)
    }
    
    func makeUIViewController(context: Context) -> VideoPlayer {
        return videoPlayer
    }

    func updateUIViewController(_ uiViewController: VideoPlayer, context: Context) {
        //nothing ?
    }
}
