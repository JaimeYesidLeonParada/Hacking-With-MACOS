//
//  View-Snapshot.swift
//  Screenable
//
//  Created by Jaime Yesid Leon Parada on 18/06/22.
//

import SwiftUI

extension View {
    func snapshot() -> Data? {
        let view = NSHostingView(rootView: self)
        view.setFrameSize(view.fittingSize)
        
        guard let bitmapRep = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
            return nil
        }
        view.cacheDisplay(in: view.bounds, to: bitmapRep)
        
        return bitmapRep.representation(using: .png, properties: [:])
    }
}
