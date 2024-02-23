//
//  MyButton.swift
//  Kiara
//
//  Created by Fabian Sand on 19.12.23.
//
 
import SwiftUI

struct MyButton: View {
    
    let iconSystemName: String
    let localizedString: String
    @Binding var tapped: Bool
    
    var body: some View {
        Button {
            
            tapped = !tapped
            
        } label: {
            HStack(spacing: 5) {
                
                Image(systemName: iconSystemName)
                    .font(.system(size: 40))
                
                Text(LocalizedStringKey(localizedString))
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
            }
        }
    }
}

struct MyButton_2: View {
    
    let iconSystemName: String
    let localizedString: String
    @Binding var tapped: Bool
    @Binding var tapped_2: Bool
    
    var body: some View {
        Button {
            
            tapped = !tapped
            tapped_2 = !tapped_2
            
        } label: {
            HStack(spacing: 5) {
                
                Image(systemName: iconSystemName)
                    .font(.system(size: 40))
                
                Text(LocalizedStringKey(localizedString))
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
            }
        }
    }
}
