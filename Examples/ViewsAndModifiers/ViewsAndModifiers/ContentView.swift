//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Jaime Yesid Leon Parada on 13/05/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
        .frame(width: 200, height: 200)
        .background(.red)
        .onAppear {
        print(type(of: self.body))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
