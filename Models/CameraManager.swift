//
//  CameraManager.swift
//  Kiara
//
//  Created by Fabian Sand on 19.10.23.
//

import AVFoundation
import UIKit
import SwiftUI


class CameraManager: NSObject, CameraManagerInterface{
    
    var videoPixelBufferPublisher: Published<CVPixelBuffer?>.Publisher { $videoPixelBuffer}
    

    lazy var previewLayer: AVCaptureVideoPreviewLayer =  AVCaptureVideoPreviewLayer(session: session) //TODO
    

    private var renderingEnabled = true

    private let session = AVCaptureSession()
    
    private var videoDeviceInput: AVCaptureDeviceInput!
    
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let depthDataOutput = AVCaptureDepthDataOutput()
    private var outputSynchronizer: AVCaptureDataOutputSynchronizer?
    
    private let movieOutput = AVCaptureMovieFileOutput()
    
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(
        deviceTypes: [.builtInTrueDepthCamera],
        mediaType: .video,
        position: .front
    )
    
    @Published var depthData: AVDepthData?
    @Published var videoPixelBuffer: CVPixelBuffer?
    
    
    //TODO For saving Video with DepthData. Not nessaray
    var captureManager: RGBDCaptureManager
    var readManager: RGBDReadManager
    
    override init() {
        readManager = RGBDReadManager()
        captureManager = RGBDCaptureManager()
        
        super.init()
        
        EnvironmentVariables.shared.sessionQueue.async {
            self.configureSession()
            self.startSession()
        }
    }
    
    public func startSession() {
        EnvironmentVariables.shared.sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    public func pauseRecording() {
        print("Not yet implementet")
    }
    
    public func startRecording(){
        self.startFileRecording()
        
        //TODO saving Video with DepthData
        self.captureManager.startRecording()
        //self.renderingEnabled = true
        
    }
    
    
    public func stopRecording(){
        //self.renderingEnabled = false
        self.movieOutput.stopRecording()
        
        //TODO stop saving Video with Deoth Data
        self.captureManager.stopRecording()
    }
    
    public func stopSession() {
        if(self.renderingEnabled) {
            self.stopRecording()
        }
            
        EnvironmentVariables.shared.sessionQueue.async {
            self.session.stopRunning()
        }
    }
    
    private func configureSession() {
        
        let defaultVideoDevice: AVCaptureDevice? = videoDeviceDiscoverySession.devices.first
        
        guard let videoDevice = defaultVideoDevice else {
            print("Could not find any video device")
            return
        }
        
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        session.beginConfiguration()
        
        //session.sessionPreset = AVCaptureSession.Preset.vga640x480
        
        // Add a video input
        if session.canAddInput(videoDeviceInput) {
            session.addInput(videoDeviceInput)
        } else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        
        // Add a video data output
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        
        if(session.canAddOutput(movieOutput)){
           session.addOutput(movieOutput)
        }else{
            print("Could Not add Movie Output")
            session.commitConfiguration()
            return
        }
        
        // Add a depth data output
        if session.canAddOutput(depthDataOutput) {
            session.addOutput(depthDataOutput)
            //depthDataOutput.isFilteringEnabled = false
        } else {
            print("Could not add depth data output to the session")
            session.commitConfiguration()
            return
        }
        
        // Search for highest resolution with half-point depth values
        let depthFormats = videoDevice.activeFormat.supportedDepthDataFormats
        let filtered = depthFormats.filter({
            CMFormatDescriptionGetMediaSubType($0.formatDescription) == kCVPixelFormatType_DepthFloat16
        })
        let selectedFormat = filtered.max(by: {
            first, second in CMVideoFormatDescriptionGetDimensions(first.formatDescription).width < CMVideoFormatDescriptionGetDimensions(second.formatDescription).width
        })
        
        do {
            try videoDevice.lockForConfiguration()
            videoDevice.activeDepthDataFormat = selectedFormat
            videoDevice.unlockForConfiguration()
        } catch {
            print("Could not lock device for configuration: \(error)")
            session.commitConfiguration()
            return
        }
        
        // Use an AVCaptureDataOutputSynchronizer to synchronize the video data and depth data outputs.
        // The first output in the dataOutputs array, in this case the AVCaptureVideoDataOutput, is the "master" output.
        outputSynchronizer = AVCaptureDataOutputSynchronizer(dataOutputs: [videoDataOutput, depthDataOutput])
        outputSynchronizer!.setDelegate(self, queue: EnvironmentVariables.shared.dataOutputQueue)
        session.commitConfiguration()
    }
    
    private func startFileRecording(){
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //let fileURL = documentURL.appendingPathComponent("testVideo.mov")
        let date = FileUtils.getFormattedDate()
        let filename = date + "_Video.mov"
        let fileURL = documentURL.appendingPathComponent(filename)
        
        do{ try FileManager.default.removeItem(at: fileURL)}
        catch {print("file delition failed. Doesnt exist or no acess")}

        
        var c = self.movieOutput.connection(with:AVMediaType.video)
        if(c != nil){
            print("Active : " + (c?.isActive.description)!)
            print("url : " + fileURL.description)
        }
        if ((c?.isActive) != nil) {
            self.movieOutput.startRecording(to: fileURL, recordingDelegate: self)
            print("starting Recording to file")
        } else {
            print(fileURL)
            print("Faild saving Video No Connection to MovieOutput")
        }
    }
}


extension CameraManager : AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if(error != nil){ print("error " + error.debugDescription)}
        else {print("file Saved")}
    }
}

extension CameraManager : AVCaptureDataOutputSynchronizerDelegate {
    
    
    func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer, didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        if !renderingEnabled { return }
        
        // Read all outputs
        guard let syncedDepthData: AVCaptureSynchronizedDepthData = synchronizedDataCollection.synchronizedData(for: depthDataOutput) as? AVCaptureSynchronizedDepthData else { return }
        guard let syncedVideoData: AVCaptureSynchronizedSampleBufferData = synchronizedDataCollection.synchronizedData(for: videoDataOutput) as? AVCaptureSynchronizedSampleBufferData else { return }
        
        if syncedDepthData.depthDataWasDropped || syncedVideoData.sampleBufferWasDropped { return }
        
        let depthData = syncedDepthData.depthData
        let sampleBuffer = syncedVideoData.sampleBuffer
        guard let videoPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let _ = CMSampleBufferGetFormatDescription(sampleBuffer) else { return }
        
        // sets data for PointCloudPreview, so that point cloud can be displayed via SwiftUI
        // @Published values have to be updated on the main thread
        DispatchQueue.main.async {
            self.depthData = depthData
            self.videoPixelBuffer = videoPixelBuffer
        }
        
        if captureManager.status == .prepareRecording || captureManager.status == .isRecording {
            //captureManager.addPixelBuffers(pixelBuffer: depthData.depthDataMap) //Tiefeninfo von Sensor
            //captureManager.addPixelBuffers(pixelBuffer: videoPixelBuffer) //RGB-Info von Sensor
        }
        
        //TODO not used so far
        if readManager.status == .prepareReading || readManager.status == .isReading {
            readManager.readPixelBuffers(pixelBuffer: depthData.depthDataMap)
            readManager.readPixelBuffers(pixelBuffer: videoPixelBuffer)
        }
    }
    
}
