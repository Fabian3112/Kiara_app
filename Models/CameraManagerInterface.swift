//
//  CameraManagerInterface.swift
//  Kiara
//
//  Created by Fabian Sand on 09.01.24.
//

import AVFoundation

protocol CameraManagerInterface :ObservableObject{
    var videoPixelBuffer : CVPixelBuffer? { get }
    var videoPixelBufferPublisher: Published<CVPixelBuffer?>.Publisher { get }
    
    func startRecording()
    func stopRecording()
    func pauseRecording()
}
