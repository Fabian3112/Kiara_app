//
//  TrainEvaluation.swift
//  Kiara
//
//  Created by Fabian Sand on 10.01.24.
//

import AVFoundation
import SwiftUI

protocol TrainEvaluation{
    func evaluate(angles:[Int]?) -> AnyView
} 
extension TrainEvaluation {
    
    func printAngle(angles:[Int]){
        
        let allAngels = [("right_elbow" , 0),
                         ("left_elbow" , 1),
                         ("right_knee" , 2),
                         ("left_knee" , 3),
                         ("right_hip" , 4),
                         ("left_hip" , 5),
                         ("right_shoulder" , 6),
                         ("left_shoulder" , 7),
                         ("knee_hip_knee" , 8)]
        
        for angle in allAngels{
            print(angle.0 + " " + angles[angle.1].description )
        }
    }
}

enum Angle : Int {
    case knee_hip_knee = 8
    case left_shoulder = 7
    case right_shoulder = 6
    case left_hip = 5
    case right_hip = 4
    case left_knee = 3
    case right_knee = 2
    case left_elbow = 1
    case right_elbow = 0
}

struct angleStep{
    let lower_angle : Int
    let higer_angle : Int
    let angle : Angle
}
