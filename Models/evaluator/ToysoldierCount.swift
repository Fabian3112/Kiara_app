//
//  toysoldierCount.swift
//  Kiara
//
//  Created by Fabian Sand on 10.02.24.
//

import Foundation
import SwiftUI

class ToysoldierCount : TrainEvaluation{
    var counter : Int = 0
    var next_step : Int = 0
    
    let possible_angles_steps : [[[angleStep]]] = [
        [[angleStep(lower_angle: 140, higer_angle: 190, angle: .left_knee) , angleStep(lower_angle: 140, higer_angle: 190, angle: .right_knee)],
        [angleStep(lower_angle: 140, higer_angle: 190, angle: .left_knee) , angleStep(lower_angle: 140, higer_angle: 190, angle: .right_knee),
         angleStep(lower_angle: 70, higer_angle: 110, angle: .right_hip) , angleStep(lower_angle: 70, higer_angle: 110, angle: .left_shoulder)], //Right hip 90 Degrees left shoulder 90 Degrees
        [angleStep(lower_angle: 140, higer_angle: 190, angle: .left_knee) , angleStep(lower_angle: 140, higer_angle: 190, angle: .right_knee)]], //This Condition is not good enough --> Is allready fullfilled in toy soldier possision
        
        
        [[angleStep(lower_angle: 140, higer_angle: 190, angle: .left_knee) , angleStep(lower_angle: 140, higer_angle: 190, angle: .right_knee)],
        [angleStep(lower_angle: 140, higer_angle: 190, angle: .left_knee) , angleStep(lower_angle: 140, higer_angle: 190, angle: .right_knee),
         angleStep(lower_angle: 70, higer_angle: 110, angle: .left_hip) , angleStep(lower_angle: 70, higer_angle: 110, angle: .right_shoulder)], //left hip 90 Degrees right shoulder 90 Degrees
        [angleStep(lower_angle: 140, higer_angle: 190, angle: .left_knee) , angleStep(lower_angle: 140, higer_angle: 190, angle: .right_knee)]]
 
    ]
    
    let step_messages : [String] = ["Go Down","Go down","Go Up","Well Done"]
    
    func evaluate(angles: [Int]?) -> AnyView {
        guard let angles = angles else {return AnyView(Text("No Angels so far"))}
        
        if next_step < possible_angles_steps[0].count {
            for angles_steps in possible_angles_steps{
                var all_angles_right = true;
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
