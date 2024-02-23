//
//  PreviewView.swift
//  Kiara
//
//  Created by Fabian Sand on 20.10.23.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI

final class PreviewView: UIView {
    
    private var cameraManager = CameraManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        //contentMode = .scaleAspectFit
        cameraManager.startSession()
    }

    public func startRecording(){
        cameraManager.startRecording()
    }

    public func stopRecording(){
        cameraManager.stopRecording()
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
        //layer.masksToBounds = true
        layer.addSublayer(cameraManager.previewLayer)
        cameraManager.previewLayer.frame = bounds
        
        
    }
}
