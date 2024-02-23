//
//  PosePrediction3D.swift
//  Kiara
//
//  Created by Fabian Sand on 20.12.23.
//

import AVFoundation
import CoreImage
import CoreML


class PosePrediction3D {
    var model : videopose3d_27f_causal_yolo?
    
    public func predict(input:[[[Double]]]) -> videopose3d_27f_causal_yoloOutput? {
        do {
            if model == nil{
                try model = videopose3d_27f_causal_yolo()
            }
            
            var multiArray = try MLMultiArray(shape: [1,27,17,2], dataType: MLMultiArrayDataType.double)
            
            for i in 0...26{
                for i2 in 0...16{
                    for i3 in 0...1{
                        multiArray[[0 as NSNumber, i as NSNumber, i2 as NSNumber, i3 as NSNumber]] = input[i][i2][i3] as NSNumber
                    }
                }
            }
            
            let netInput = videopose3d_27f_causal_yoloInput(x_1: multiArray)
            let prediction = try model!.prediction(input: netInput)
            return prediction
        }
        catch {
            return  nil
        }
    }
    
}
