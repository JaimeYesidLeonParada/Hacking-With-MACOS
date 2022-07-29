//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Jaime Yesid Leon Parada on 22/07/22.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { _ in
                    dataController.save()
                }
        }
    }
}
