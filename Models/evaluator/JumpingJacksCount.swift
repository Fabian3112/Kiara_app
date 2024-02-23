//
//  JumpingJacksCount.swift
//  Kiara
//
//  Created by Fabian Sand on 18.01.24.
//

import Foundation
import SwiftUI

class JumpingJacksCount : TrainEvaluation{
    
    var counter : Int = 0
    var next_step : Int = 0
    
    let angles_steps : [[angleStep]] = [
        
        [angleStep(lower_angle: 140, higer_angle: 190, angle: .left_knee),      // left knee straight
         angleStep(lower_angle: 140, higer_angle: 190, angle: .right_knee),     //Right knee straight
        angleStep(lower_angle: 50, higer_angle: 90, angle: .knee_hip_knee)],   //leg spread 60 Degrees
        
        [angleStep(lower_angle: 140, higer_angle: 190, angle: .left_knee)   , angleStep(lower_angle: 140, higer_angle: 190, angle: .right_knee), //knees straight
         angleStep(lower_angle: 140, higer_angle: 190, angle: .left_hip)    , angleStep(lower_angle: 140, higer_angle: 190, angle: .right_hip),  // hips straight
         angleStep(lower_angle: 0, higer_angle: 40, angle: .knee_hip_knee)],    //legs together
        
//        [angleStep(lower_angle: 160, higer_angle: 190, angle: .left_knee),      // left knee straight
//         angleStep(lower_angle: 160, higer_angle: 190, angle: .right_knee),     //Right knee straight
//         angleStep(lower_angle: 60, higer_angle: 190, angle: .knee_hip_knee)],  //leg spread 90 Degrees
//        
//        [angleStep(lower_angle: 160, higer_angle: 190, angle: .left_knee)   , angleStep(lower_angle: 160, higer_angle: 190, angle: .right_knee), //knees straight
//         angleStep(lower_angle: 160, higer_angle: 190, angle: .left_hip)    , angleStep(lower_angle: 160, higer_angle: 190, angle: .right_hip),  // hips straight
//         angleStep(lower_angle: 0, higer_angle: 40, angle: .knee_hip_knee)],    //legs together
        ]
    
    let step_messages : [String] = ["jump","jump back","jump", "jump back", "Well Done"]
    
    func evaluate(angles: [Int]?) -> AnyView {
        guard let angles = angles else {return AnyView(Text("No Angels so far"))}
        printAngle(angles: angles)
        
        var all_angles_right = true
        
        if next_step < angles_steps.count {
            for angle_step in angles_steps[next_step]{
                let angle_meassured = angles[angle_step.angle.rawValue]
                if angle_meassured < angle_step.higer_angle && angle_meassured > angle_step.lower_angle{
                    
                }else{
                    all_angles_right = false
                }
            }
        }else{
            all_angles_right = false
        }
        
        if(all_angles_right){
            next_step += 1
            if next_step >= angles_steps.count{
                counter += 1
                if counter < 10 {
                    next_step =  0
                }
            }
        }
        
        return AnyView(VStack{
            Text(step_messages[next_step])
            Text("Counter : " + counter.description)
        })
        
    }
}
