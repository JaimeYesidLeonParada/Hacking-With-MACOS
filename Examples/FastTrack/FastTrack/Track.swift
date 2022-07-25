//
//  Track.swift
//  FastTrack
//
//  Created by Jaime Yesid Leon Parada on 27/05/22.
//

import Foundation

struct SearchResult: Decodable {
    let results: [Track]
}

struct Track: Identifiable, Decodable {
    var id: Int { trackId }
    
    let trackId: Int
    let artistName: String
    let trackName: String
    let previewUrl: URL
    let artworkUrl100: String
    
    var artworkURL: URL? {
        let replacedString = artworkUrl100.replacingOccurrences(of: "100x100", with: "300x300")
        return URL(string: replacedString)
    }
}
