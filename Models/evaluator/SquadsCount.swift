//
//  SquadsCount.swift
//  Kiara
//
//  Created by Fabian Sand on 10.01.24.
//

import Foundation
import SwiftUI

class SquadsCount : TrainEvaluation{
    var counter : Int = 0
    var next_step : Int = 0
    
    let angles_steps : [[angleStep]] = [
        [angleStep(lower_angle: 140, higer_angle: 160, angle: .left_knee) , angleStep(lower_angle: 140, higer_angle: 160, angle: .right_knee) ],
        [angleStep(lower_angle: 80, higer_angle: 120, angle: .left_knee) , angleStep(lower_angle: 80, higer_angle: 120, angle: .right_knee) ],
        [angleStep(lower_angle: 140, higer_angle: 160, angle: .left_knee) , angleStep(lower_angle: 140, higer_angle: 160, angle: .right_knee) ],
    ]
    
    let step_messages : [String] = ["Go Down","Go down","Go Up","Well Done"]
    
    func evaluate(angles: [Int]?) -> AnyView {
        guard let angles = angles else {return AnyView(Text("No Angels so far"))}
        //printAngle(angles: angles)
        
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
                if counter < 5 {
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


