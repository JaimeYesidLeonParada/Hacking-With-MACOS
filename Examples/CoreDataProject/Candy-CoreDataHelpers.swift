//
//  Candy-CoreDataHelpers.swift
//  CoreDataProject
//
//  Created by Jaime Yesid Leon Parada on 28/07/22.
//

import Foundation

extension Candy {
    var candyName: String {
        name ?? "Unlnown Candy"
    }
}

extension Country {
    var countryShortName: String {
        shortName ?? "Unknown Country"
    }
    
    var countryFullName: String {
        fullName ?? "Unknown Country"
    }
    
    var countryCandy: [Candy] {
        let set = candy as? Set<Candy> ?? []
        
        return set.sorted {
            $0.candyName < $1.candyName
        }
    }
}
