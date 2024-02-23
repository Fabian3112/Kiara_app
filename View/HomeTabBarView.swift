//
//  TabBarView.swift
//  InferMod3D-Recorder
//
//  Created by Fabian Rapp on 09.03.22.
//

import SwiftUI

/// Displays a blue bar with buttons that navigate to all main views of the app.
struct HomeTabBarView: View {
    
    //@State private var showScanView = false
    @Binding var isPresented: Bool

    var body: some View {
        
        HStack(alignment: .bottom) {
            
            Spacer()
            
            
            TabBarItem(iconSystemName: "arrow.clockwise.circle.fill", tapped: $isPresented)
            
            Spacer()
        }
        .blueButtonBarStyle()
    }
}


extension View {
    
    func blueButtonBarStyle() -> some View {
        modifier(BlueButtonBarStyle())
    }
}


struct BlueButtonBarStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
    }
}

