//
//  TabBarItem.swift
//  Kiara
//
//  Created by Fabian Sand on 19.10.23.
//

import SwiftUI

struct TabBarItem: View {
    
    let iconSystemName: String
    @Binding var tapped: Bool
    
    var body: some View {
        
        VStack(spacing: 5) {
            Button {
                
                tapped = !tapped
                
            } label: {
                Image(systemName: iconSystemName)
                    .font(.system(size: 40))
            }
            .foregroundColor(.white)
        }
    }
}
 
 
