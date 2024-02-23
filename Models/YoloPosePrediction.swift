//
//  YoloPosePrediction.swift
//  Kiara
//
//  Created by Fabian Sand on 04.12.23.
//

import Foundation
import CoreImage
import CoreML

class Yolo_prediction{
    var model : yolov8s_pose?// YoloPose?

    public func predict(image: CVPixelBuffer) -> yolov8s_poseOutput?{
        guard let resizedImage = PosePrediction.resizePixelBuffer(image, width: 640, height: 640) else {
            print("too bad")
                fatalError("Unexpected runtime error. while resizing image")
        }
        
        
        do {
            if model == nil {
                try model = yolov8s_pose()
            }
            return try model!.prediction(input: yolov8s_poseInput(image: resizedImage))
            }
        catch{
                 fatalError("Unexpected runtime error. while initiating 2D Pose Model")
        }
    }
    
}
