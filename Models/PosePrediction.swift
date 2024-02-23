//
//  posePrediction.swift
//  Kiara
//
//  Created by Fabian Sand on 20.11.23.
//

import AVFoundation
import CoreImage

class PosePrediction{
     /*let model = PoseNetMobileNet100S16FP16()
     var prediction : PoseNetMobileNet100S16FP16Output?
     var poseNetOutput : PoseNetOutput?
     
    public func predict(image: CVPixelBuffer) -> PoseNetOutput?{
        guard let resizedImage = PosePrediction.resizePixelBuffer(image, width: 513, height: 513) else {
            fatalError("Unexpected runtime error. while resizing image")
        }
        let input = PoseNetMobileNet100S16FP16Input(image: resizedImage)
        
         guard let prediction = try? self.model.prediction(input:input) else {
             print("Error in prediction")
             return nil
        }
        
        let poseNetOutput = PoseNetOutput(prediction: prediction,
                                          modelInputSize: CGSize(width: 513, height: 513),
                                          modelOutputStride: 16)
        self.prediction = prediction
        self.poseNetOutput = poseNetOutput
        
        return poseNetOutput
     }
    
    
    /**
      Resizes a CVPixelBuffer to a new width and height, using Core Image.
     https://github.com/hollance/CoreMLHelpers/blob/master/CoreMLHelpers/CVPixelBuffer%2BResize.swift TODO
    */
      
    */
    public static func resizePixelBuffer(_ pixelBuffer: CVPixelBuffer,
                                  width: Int, height: Int) -> CVPixelBuffer? {
        
        var ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        ciImage = ciImage.oriented(.up)
        
        let sx = CGFloat(width) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(height) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        print(sx)
        print(sy)
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        
        let context = CIContext()
        
        let scaledImage = ciImage.transformed(by: scaleTransform)
        
        var pixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        CVPixelBufferCreate(kCFAllocatorDefault,
                            width,
                            height,
                            kCVPixelFormatType_32BGRA,
                            attrs,
                            &pixelBuffer)
        
        
        if let unwrappedPixelBuffer = pixelBuffer{
            
            context.render(scaledImage, to: unwrappedPixelBuffer)
            return unwrappedPixelBuffer
        }else{
            return nil
        }
        
    }
    
    public static func squarePixelBuffer(_ pixelBuffer: CVPixelBuffer,
                                         width: Int, height: Int, rotate: Bool) -> CVPixelBuffer? {
        
        
        var ciImage =  CIImage(cvPixelBuffer: pixelBuffer)
        if rotate{
            ciImage = ciImage.oriented(.right)
        } else {
            ciImage = ciImage.oriented(.upMirrored)
            //ciImage = ciImage.oriented(.left) TODO tried and far worse
        }
                
        
        let srcWidth  = CGFloat(ciImage.extent.width)
        let srcHeight = CGFloat(ciImage.extent.height)
        
            //let dstWidth: CGFloat = 1080
        //let dstHeight: CGFloat = 1920

        //let scaleX = dstWidth / srcWidth
        //let scaleY = dstHeight / srcHeight
        //let scale = min(scaleX, scaleY)
        
        //let transform = CGAffineTransform.init(scaleX: scale, y: scale)
        //ciImage = ciImage.transformed(by: transform).cropped(to: CGRect(x: 0, y: 0, width: dstWidth, height: dstHeight))

        
        let context = CIContext()
        
        var pixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        
        CVPixelBufferCreate(kCFAllocatorDefault,
                            width,
                            height,
                            kCVPixelFormatType_32BGRA,
                            attrs,
                            &pixelBuffer)
        
        
        if let unwrappedPixelBuffer = pixelBuffer{
            
            context.render(ciImage, to: unwrappedPixelBuffer)
            return unwrappedPixelBuffer
        }else{
            return nil
        }
    }
 }
 
