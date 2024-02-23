//
//  WaitView.swift
//  Kiara
//
//  Created by Fabian Sand on 10.01.24.
//

import SwiftUI

struct WaitView<T: View>: View {
    
    let nextView: T
    @Binding var presentNext:Bool
    
    var body: some View {
        Text("Loading Please Wait").fullScreenCover(isPresented: $presentNext, content: {nextView})
    }
}
