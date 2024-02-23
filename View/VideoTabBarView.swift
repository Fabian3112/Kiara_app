//
//  VideoTabBarView.swift
//  Kiara
//
//  Created by Fabian Sand on 19.12.23.
//
import SwiftUI

struct VideoTabBarView: View {
    
    @Binding var isPresented: Bool
    @Binding var showCameraView: Bool
    
    var body: some View {
        
        HStack(alignment: .bottom) {
            
            Spacer()
            
            
            TabBarItem(iconSystemName: "arrow.clockwise.circle.fill", tapped: $isPresented)
            
            Spacer()
            
            VStack(spacing: 5) {
                Button {
                    
                    isPresented = false
                    showCameraView = true
                    
                } label: {
                    Image(systemName: "arrowtriangle.right.circle.fill")
                        .font(.system(size: 40))
                }
                .foregroundColor(.white)
            }
            
            /*TabBarItem(iconSystemName: "arrowtriangle.right.circle.fill", tapped: $showCameraView).fullScreenCover(isPresented: $showCameraView, content: {
                CameraView(isPresented: $showCameraView)
            })*/
            /*
            VStack(spacing: 5) {
                Button {
                    fakeView.anyView = AnyView(CameraView(isPresented: $isPresented))
                } label: {
                    Image(systemName: "arrowtriangle.right.circle.fill")
                        .font(.system(size: 40))
                }
                .foregroundColor(.white)
            }
            */
            Spacer()
        }.blueButtonBarStyle()
    }
}
