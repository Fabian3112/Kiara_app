//
//  VideoPlayback.swift
//  Kiara
//
//  Created by Fabian Sand on 09.01.24.
//

import Foundation
import AVFoundation


class VideoPlayback : CameraManagerInterface{
    var videoPixelBufferPublisher: Published<CVPixelBuffer?>.Publisher { $videoPixelBuffer }
    
    private var isRecording = false
    
    func pauseRecording() {
        isRecording = false
    }
    
    func startRecording() {
        if reader == nil{
            return
        }
        
        if !isRecording{
            isRecording = true
            
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                if(!self.isRecording){
                    timer.invalidate()
                    return
                }
                /*if self.reader!.canAdd(self.output!){
                    self.reader!.add(self.output!)
                    print("this should not happen")
                }else{
                    print("could not add output")
                }*/
                DispatchQueue.main.async {
                    let cmbuffer = self.output!.copyNextSampleBuffer()
                    if cmbuffer == nil{
                        timer.invalidate()
                        return
                    }
                    self.captureOutput(sampleBuffer: cmbuffer!)
                }
            }
        }
    }
    
    func stopRecording() {
        isRecording = false
        if reader == nil{
            return
        }
        reader?.cancelReading()
    }
    
    
    @Published var videoPixelBuffer: CVPixelBuffer?
    
    let videoName:String
    var reader : AVAssetReader?
    var output : AVAssetReaderVideoCompositionOutput?
    
    init(video_name:String = "TestVideo_3") {
        self.videoName = video_name
        
        guard let path = Bundle.main.path(forResource: videoName, ofType:"mp4") else {
            return
        }
        
        do{
            try self.reader = AVAssetReader(asset:AVAsset(url: URL(fileURLWithPath: path)) )
        }catch{
            debugPrint("Error initialising asset reader")
            self.reader = nil
            return
        }
        output = AVAssetReaderVideoCompositionOutput(videoTracks: reader!.asset.tracks(withMediaType: .video), videoSettings: nil)
        output?.videoComposition = AVVideoComposition(propertiesOf: AVAsset(url: URL(fileURLWithPath: path)))
        //reader!.add(output!)
        if self.reader!.canAdd(self.output!){
            self.reader!.add(self.output!)
            print("this should not happen")
        }else{
            print("could not add output")
        }
        
        //Load first image
        reader?.startReading()
        let cmbuffer = self.output!.copyNextSampleBuffer()
        self.captureOutput(sampleBuffer: cmbuffer!)
    }
    
    func captureOutput( sampleBuffer: CMSampleBuffer) {
        guard let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        self.videoPixelBuffer = imageBuffer
    }
}
