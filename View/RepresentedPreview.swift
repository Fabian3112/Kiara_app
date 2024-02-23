//
//  RepresentedPreview.swift
//  Kiara
//
//  Created by Fabian Sand on 23.10.23.
//

import SwiftUI

struct RepresentedPreview: UIViewRepresentable {
    typealias UIViewType = PreviewView
    let view = PreviewView()
    
    func makeUIView(context: Context) -> PreviewView {
        return view
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {
        //Nothing here
    }
    
    func startRecording(){
        view.startRecording()
    }
    
    func stopRecording(){
        view.stopRecording()
    }
}
