//
//  GameView.swift
//  ShootingGallery
//
//  Created by Jaime Yesid Leon Parada on 25/06/22.
//

import Cocoa
import SpriteKit

class GameView: SKView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func resetCursorRects() {
        if let targetImage = NSImage(named: "cursor") {
            let cursor = NSCursor(image: targetImage, hotSpot: CGPoint(x: targetImage.size.width / 2, y: targetImage.size.height / 2))
            addCursorRect(frame, cursor: cursor)
        }
    }
    
}
