//
//  Review-CoreDataHelpers.swift
//  Bookworm
//
//  Created by Jaime Yesid Leon Parada on 4/07/22.
//

import Foundation

extension Review {
    var reviewTitle: String {
        get { title ?? ""}
        set {
            guard managedObjectContext != nil else { return }
            title = newValue
        }
    }
    
    var reviewAuthor: String {
        get { author ?? ""}
        set {
            guard managedObjectContext != nil else { return }
            author = newValue
        }
    }
    
    var reviewText: String {
        get { text ?? ""}
        set {
            guard managedObjectContext != nil else { return }
            text = newValue
        }
    }
}
