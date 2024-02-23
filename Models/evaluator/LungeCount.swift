//
//  LungeCount.swift
//  Kiara
//
//  Created by Fabian Sand on 14.01.24.
//
import Foundation
import SwiftUI

class LungeCount : TrainEvaluation{
    
    var counter : Int = 0
    var next_step : Int = 0
    
    let possible_angles_steps : [[[angleStep]]] = [[
        [angleStep(lower_angle: 80, higer_angle: 120, angle: .left_knee) , angleStep(lower_angle: 80, higer_angle: 120, angle: .right_knee), //knees bound almost 90 Degrees
         angleStep(lower_angle: 140, higer_angle: 180, angle: .left_hip) , angleStep(lower_angle: 80, higer_angle: 120, angle: .right_hip)], //left hip straight, right hip 90 Degrees,
        [angleStep(lower_angle: 140, higer_angle: 180, angle: .left_knee) , angleStep(lower_angle: 140, higer_angle: 180, angle: .right_knee) ] //knees straight
        ],
        [[angleStep(lower_angle: 80, higer_angle: 120, angle: .left_knee) , angleStep(lower_angle: 80, higer_angle: 120, angle: .right_knee), //knees bound almost 90 Degrees
         angleStep(lower_angle: 140, higer_angle: 180, angle: .right_hip) , angleStep(lower_angle: 80, higer_angle: 120, angle: .left_hip)], //right hip straight, left hip 90 Degrees
        
       [angleStep(lower_angle: 140, higer_angle: 180, angle: .left_knee) , angleStep(lower_angle: 140, higer_angle: 180, angle: .right_knee) ] //knees straight
    ]]
    
    
    
    let step_messages : [String] = ["step forward","step back", "Well Done"]
    
    func evaluate(angles: [Int]?) -> AnyView {
        guard let angles = angles else {return AnyView(Text("No Angels so far"))}
        printAngle(angles: angles)
        
        var all_angles_right = true
        
        if next_step < possible_angles_steps[0].count {
            for angles_steps in possible_angles_steps{
                all_angles_right = true;
                for angle_step in angles_steps[next_step]{
                    let angle_meassured = angles[angle_step.angle.rawValue]
                    if angle_meassured < angle_step.higer_angle && angle_meassured > angle_step.lower_angle{
                        
                    }else{
                        all_angles_right = false
                    }
                }
                
                if(all_angles_right){
                    next_step += 1
                    if next_step >= angles_steps.count{
                        counter += 1
                        if counter < 10 {
                            next_step =  0
                        }
                    }
                    break;
                }
            }
            
        }
        
        
        return AnyView(VStack{
            Text(step_messages[next_step])
            Text("Counter : " + counter.description)
        })
        
    }
    
}
