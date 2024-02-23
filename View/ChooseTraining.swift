//
//  ChooseTraining.swift
//  Kiara
//
//  Created by Fabian Sand on 13.12.23.
//

import SwiftUI

enum trainings {
    case squats
    case lunges
    case tree
    case side_lunge_left
    case side_lunge_right
    case jumping_jacks
    case toy_soldier
}

struct ChooseTraining: View {
    @State private var selection: String?
    @Binding var isPresented: Bool
    
    @State var showVideoPlayertree = false
    @State var showVideoPlayerlunges = false
    @State var showVideoPlayersquads = false
    @State var showVideoPlayersideLungeLeft = false
    @State var showVideoPlayersideLungeRight = false
    @State var showVideoPlayerJumpingJacks = false
    @State var showVideoPlayerToySoldier = false
    
    @State var showCameraSquads = false
    @State var showCameraTree = false
    @State var showCameraLunges = false
    @State var showCamerasideLungeLeft = false
    @State var showCamerasideLungeRight = false
    @State var showCameraJumpingJacks = false
    @State var showCameraToySoldier = false
    
    @State var showCameraView = false
    @State var showResultView = false
    @State var developerMode = false
    
    @State var training_chosen = trainings.squats
    @State var count = 0
    let predictions = Predictions()
    let video_names = [
        "s01",
        "s02",
        //"s03",
        "s04",
        "s05",
        "s06",
        "s07",
        "s08"
        //"s09",
    ]
    var body: some View {
            
        
            NavigationView {
                ZStack(alignment: .bottom) {
                    
                    if(developerMode && selection == nil){
                        List(video_names, id: \.self, selection: $selection) { name in
                            Text(name).padding(5)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        .frame(minHeight: 200)
                    }else{
                        
                        List {
                            
                            
                            //Spacer(minLength: 0).padding(0)
                            getTrainingButton(training: trainings.squats, trainPreviewPresented: $showVideoPlayersquads , showNext: $showCameraSquads, showResult: $showResultView)
                            
                            getTrainingButton(training: trainings.lunges, trainPreviewPresented: $showVideoPlayerlunges , showNext: $showCameraLunges, showResult: $showResultView)
                            
                            getTrainingButton(training: trainings.tree, trainPreviewPresented: $showVideoPlayertree , showNext: $showCameraTree, showResult: $showResultView)
                            
                            getTrainingButton(training: trainings.side_lunge_left, trainPreviewPresented: $showVideoPlayersideLungeLeft, showNext: $showCamerasideLungeLeft, showResult: $showResultView)
                            
                            getTrainingButton(training: trainings.side_lunge_right, trainPreviewPresented: $showVideoPlayersideLungeRight, showNext: $showCamerasideLungeRight, showResult: $showResultView)
                            
                            getTrainingButton(training: trainings.jumping_jacks, trainPreviewPresented: $showVideoPlayerJumpingJacks , showNext: $showCameraJumpingJacks, showResult: $showResultView)
                            
                            getTrainingButton(training: trainings.toy_soldier, trainPreviewPresented: $showVideoPlayerToySoldier , showNext: $showCameraToySoldier, showResult: $showResultView)
                            
                            /*
                             MyButton(iconSystemName: "camera.circle.fill", localizedString: "lunges", tapped: $showVideoPlayerlunges>>).fullScreenCover(isPresented: $showVideoPlayerlunges, onDismiss : dismiss_lunges, content: {
                             show_video_view(trainings.lunges, isPresented: $showVideoPlayerlunges, video_name: "IMG_0155")
                             }).padding(20)
                             
                             MyButton(iconSystemName: "camera.circle.fill", localizedString: "tree Pose", tapped: $showVideoPlayertree ).fullScreenCover(isPresented: $showVideoPlayertree, onDismiss : dismiss_tree, content: {
                             show_video_view(trainings.tree, isPresented: $showVideoPlayertree, video_name: "IMG_0155")
                             }).padding(20)
                             */
                            
                            Toggle("Deveoper Mode", isOn: $developerMode).onChange(of: developerMode) {newValue in
                                if newValue {
                                    selection = nil
                                }
                            }
                            
                            Spacer(minLength: 20)
                        }.listRowSpacing(20)
                            .padding(.top, 20)
                        
                    }
                    HomeTabBarView(isPresented:$isPresented)
                        /*.fullScreenCover(isPresented: $showResultView, content: {
                        ResultView(isPresented: $showResultView, stored3DPredictions: predictions.stored3DPredictions, storedAnglePredictions: predictions.storedAnglePredictions)
                    })*/
                    
                }.navigationTitle("Kiara").background(.blue).navigationBarTitleDisplayMode(.inline)
        }
    }
    
    public func getTrain_Videoname(training: trainings) -> String {
        
        if selection  == nil {
            selection = "s08"
        }
        switch training {
        case .squats:
            return selection! + "_squat"
        case .lunges:
            return selection! + "_lunge"
        case .tree:
            return selection! + "_tree-pose"
        case .side_lunge_left:
            return selection! + "_side-lunge-left"
        case .side_lunge_right:
            return selection! + "_side-lunge-right"
        case .jumping_jacks:
            return selection! + "_jumping-jack"
        case .toy_soldier:
            return selection! + "_toy-soldier"
        }
    
    }
    
    
    public func getTrain_previewVideoName(training: trainings) -> String {
        switch training {
        case .squats:
            return "squat_example"
        case .lunges:
            return "IMG_0154"
        case .tree:
            return "IMG_0155"
        case .side_lunge_left:
            return "IMG_0155"
        case .side_lunge_right:
            return "IMG_0155"
        case .jumping_jacks:
            return "IMG_0155"
        case .toy_soldier:
            return "IMG_0155"
        }
    }
    
    private func getTrain_Evaluator(training: trainings) -> TrainEvaluation {
        switch training {
        case .squats:
            return SquadsCount()
        case .lunges:
            return LungeCount()
        case .tree:
            return TreePoseCount() //TODO
        case .side_lunge_left:
            return SideLungeLeftCount()
        case .side_lunge_right:
            return SideLungeRightCount()
        case .jumping_jacks:
            return JumpingJacksCount()
        case .toy_soldier:
            return ToysoldierCount()
        }
    }
    
    private func getTrain_Name(training: trainings) -> String {
        switch training {
        case .squats:
            return "squats"
        case .lunges:
            return "lunges"
        case .tree:
            return "tree pose"
        case .side_lunge_left:
            return "sidelunge left"
        case .side_lunge_right:
            return "sidelunge right"
        case .jumping_jacks:
            return "jumping jacks"
        case .toy_soldier:
            return "toy soldier"
        }
    }
    
    func dismiss_squats(){
        self.training_chosen = trainings.squats
    }
    func dismiss_lunges(){
        self.training_chosen = trainings.lunges
    }
    func dismiss_tree(){
        self.training_chosen = trainings.tree
    }
    
    private func getTrainingButton(training:trainings , trainPreviewPresented:Binding<Bool> ,showNext:Binding<Bool>, showResult: Binding<Bool>) -> some View{
        let name = getTrain_Name(training: training)
        let previewvideoName = getTrain_previewVideoName(training: training)
    
        
        return MyButton(iconSystemName: "camera.circle.fill", localizedString: name, tapped: trainPreviewPresented).fullScreenCover(isPresented: trainPreviewPresented, content: {
            PlayVideoView(isPresented: trainPreviewPresented, showCameraView: showNext,videoName: previewvideoName)
        }).padding(20).fullScreenCover(isPresented: showNext, content: {
            
            if  developerMode {
                //WaitView(nextView:
                            CameraView<VideoPlayback>(isPresented: showNext, cameraManager: VideoPlayback(video_name: getTrain_Videoname(training: training)), predictions: predictions, developerMode: developerMode, train_evaluator: TrainEvaluator(training: training))//,presentNext: showNext)
            } else {
                //WaitView(nextView:
                            CameraView<CameraManager>(isPresented: showNext, cameraManager: CameraManager(), predictions: predictions, developerMode: developerMode, train_evaluator: TrainEvaluator(training: training))//,presentNext: showNext)
            }
            
        })
    }
}

