//
//  StormViewerApp.swift
//  StormViewer
//
//  Created by Jaime Yesid Leon Parada on 11/05/22.
//

import SwiftUI

@main
struct StormViewerApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                    NSWindow.allowsAutomaticWindowTabbing = false
            }
        }.commands{
            CommandGroup(replacing: .newItem){}
            CommandGroup(replacing: .undoRedo){}
            CommandGroup(replacing: .pasteboard){}
        }
    }
}
