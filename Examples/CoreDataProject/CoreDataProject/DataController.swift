//
//  DataController.swift
//  Bookworm
//
//  Created by Jaime Yesid Leon Parada on 4/07/22.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CoreDataProject")
    var saveTask: Task<Void, Error>?
    
    init(){
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    func save(){
        guard container.viewContext.hasChanges else { return }
        try? container.viewContext.save()
    }
    
    func enqueueSave(_ change: Any) {
        saveTask?.cancel()
        saveTask = Task { @MainActor in
            try await Task.sleep(nanoseconds: 5_000_000_000)
            save()
        }
    }
}
