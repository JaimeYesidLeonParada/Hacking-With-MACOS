//
//  ContentView.swift
//  FastTrack
//
//  Created by Jaime Yesid Leon Parada on 27/05/22.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    enum SearchState {
        case none, searching, success, error
    }
    
    @AppStorage("searchText") var searchText = ""
    @State private var tracks = [Track]()
    @State private var audioPlayer: AVPlayer?
    @State private var searchState = SearchState.none
    
    let gridItems: [GridItem] = [
        GridItem(.adaptive(minimum: 150, maximum: 200))
    ]
    
    var body: some View {
        VStack {
            HStack{
                TextField("Search for a song", text: $searchText)
                    .onSubmit(startSearch)
                Button("Search", action: startSearch)
            }
            .padding([.top, .horizontal])
            
            switch searchState {
            case .none:
                Text("Enter a search term to begin.")
                    .frame(maxHeight: .infinity)
            case .searching:
                ProgressView()
                    .frame(maxHeight: .infinity)
            case .success:
                ScrollView{
                    LazyVGrid(columns: gridItems) {
                        ForEach(tracks) { track in
                            TrackView(track: track, onSelected: play)
                        }
                    }
                    .padding()
                }
            case .error:
                Text("Sorry, your search failed - please check your internet connection the try again.")
                    .frame(maxHeight: .infinity)
            }
        }
    }
    
    func startSearch(){
        searchState = .searching
        
        Task{
            do {
                try await performSearch()
                searchState = .success
            } catch {
                searchState = .error
            }
        }
    }
    
    func performSearch() async throws {
        guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchText)&limit=100&entity=song") else { return }
        let (data, _) = try await URLSession.shared.data(from: url)
        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
        tracks = searchResult.results
    }
    
    func play(_ track: Track){
        audioPlayer?.pause()
        audioPlayer = AVPlayer(url: track.previewUrl)
        audioPlayer?.play()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
