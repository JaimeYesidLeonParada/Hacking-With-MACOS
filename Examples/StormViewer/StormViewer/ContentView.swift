//
//  ContentView.swift
//  StormViewer
//
//  Created by Jaime Yesid Leon Parada on 11/05/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedImage: Int?
    
    var body: some View {
        NavigationView {
            List(0..<10, selection: $selectedImage) { number in
                Text("Storm \(number + 1)")
            }.frame(width: 150)
            
            
            if let selectedImage = selectedImage {
                Image(String(selectedImage))
                    .resizable()
                    .scaledToFit()
            } else {
                Text("Please select an image").frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Storm View")
        .frame(minWidth: 480, minHeight: 320)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
