//
//  HomeView.swift
//  Kiara
//
//  Created by Fabian Sand on 19.10.23.
//

import SwiftUI
import Charts

struct HomeView: View {
    
//    @State private var showCameraView = false
    @State private var showChooseTraining = false
    
    var body: some View {
        
            MyButton(iconSystemName: "camera.circle.fill", localizedString: "Kiara", tapped: $showChooseTraining).fullScreenCover(isPresented: $showChooseTraining, content: {
                ChooseTraining(isPresented: $showChooseTraining, training_chosen: trainings.squats)
            })
    }
}


#Preview {
    HomeView()
}

