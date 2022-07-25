//
//  ContentView.swift
//  Bookworm
//
//  Created by Jaime Yesid Leon Parada on 4/07/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ListingView()
                .frame(minWidth: 250)
            Text("Please select a review")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
