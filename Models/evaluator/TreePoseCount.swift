//
//  TreePoseCount.swift
//  Kiara
//
//  Created by Fabian Sand on 18.01.24.
//

import Foundation
import SwiftUI

class TreePoseCount : TrainEvaluation{
    
    let possible_angles : [[angleStep]] = [[angleStep(lower_angle: 140, higer_angle: 190, angle: .left_knee),      // left knee straight
                    angleStep(lower_angle: 40, higer_angle: 100, angle: .right_knee)],      //Right knee 90 Degrees
                    //angleStep(lower_angle: 60, higer_angle: 90, angle: .knee_hip_knee)],    //leg spread 90 Degrees
                    //angleStep(lower_angle: 80, higer_angle: 120, angle: .left_elbow),      //ellbow 90 Degrees
                    //angleStep(lower_angle: 80, higer_angle: 120, angle: .right_elbow)],
                                      
                    [angleStep(lower_angle: 140, higer_angle: 190, angle: .right_knee),     // right knee straight
                    angleStep(lower_angle: 40, higer_angle: 100, angle: .left_knee)],        //left knee 90 Degrees
                    //angleStep(lower_angle: 60, higer_angle: 90, angle: .knee_hip_knee)]     //leg spread 90 Degrees
                    //angleStep(lower_angle: 80, higer_angle: 120, angle: .left_elbow),       //ellbow 90 Degrees
                    //angleStep(lower_angle: 80, higer_angle: 120, angle: .right_elbow)]
    ]
    func evaluate(angles: [Int]?) -> AnyView {
        
        
        
        guard let angles = angles else {return AnyView(Text("No Angels so far"))}
        printAngle(angles: angles)
        
       
        
        for anglesteps in possible_angles {
            var all_angles_right = true
            for angle in anglesteps{
                let angle_meassured = angles[angle.angle.rawValue]
                if angle_meassured < angle.higer_angle && angle_meassured > angle.lower_angle{
                    
                }else{
                    all_angles_right = false
                }
            }
            
            if(all_angles_right){
                return AnyView(Text("Good keep in position"))
            }
        }
        
        return AnyView(Text("Get in position"))
        
    }
}
