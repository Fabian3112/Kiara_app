//
//  trainEvauator.swift
//  Kiara
//
//  Created by Fabian Sand on 18.01.24.
//

import AVFoundation
import SwiftUI
class TrainEvaluator{
    var training : trainings
    var evaluator:TrainEvaluation?
    
    init(training: trainings) {
        self.training = training
        evaluator = nil
    }
    
    public func evaluate(angles:[Int]?) -> AnyView{
        if(self.evaluator == nil){
            switch training {
            case .squats:
                evaluator = SquadsCount()
            case .lunges:
                evaluator = LungeCount()
            case .tree:
                evaluator = TreePoseCount() //TODO
            case .side_lunge_left:
                evaluator = SideLungeLeftCount()
            case .side_lunge_right:
                evaluator = SideLungeRightCount()
            case .jumping_jacks:
                evaluator = JumpingJacksCount()
            case .toy_soldier:
                evaluator = ToysoldierCount()
            }
        }
        
        return evaluator!.evaluate(angles: angles)
    }
}
