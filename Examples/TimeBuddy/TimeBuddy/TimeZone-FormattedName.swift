//
//  TimeZone-FormattedName.swift
//  TimeBuddy
//
//  Created by Jaime Yesid Leon Parada on 3/06/22.
//

import Foundation

extension TimeZone {
    var formattedName: String {
        let start = localizedName(for: .generic, locale: .current) ?? "Unknown"
        
        return "\(start) - \(identifier)"
    }
}
