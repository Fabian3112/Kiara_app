//
//  VideoPlayer.swift
//  Kiara
//
//  Created by Fabian Sand on 19.12.23.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayer: UIViewController {
    
    var videoName:String = "IMG_0155"
    
    convenience init(videoName:String) {
        self.init()
        self.videoName = videoName
        print(videoName)
        }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
    }

    private func playVideo() {
        
        guard let path = Bundle.main.path(forResource: videoName, ofType:"MOV") else {
            debugPrint("video.m4v not found")
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        playerController.view.frame = self.view.bounds
        self.view.addSubview(playerController.view)
        self.addChild(playerController)
        
        //player.currentItem?.step(byCount: 1) //TODO Use in Camera View :) --------- (:
        
        player.play()
        //present(playerController, animated: true) {
        //    player.play()
        //}
    }
}
