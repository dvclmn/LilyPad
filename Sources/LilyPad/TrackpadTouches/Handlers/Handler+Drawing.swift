//
//  Handler+Drawing.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI

@Observable
final class DrawingHandler: DrawingCommandHandler {

  var strokeHandler = StrokeHandler()
  var isPointerLocked: Bool = false

  init() {
    print("`DrawingHandler` created at \(Date.now.format(.timeDetailed))")
  }
  
}

extension DrawingHandler {
  
  var shouldShowTouchIndicators: Bool {
    return strokeHandler.eventData.touches.count > 1 && !isInTouchMode 
  }
  
  public func clearStrokes() {
    strokeHandler.clearStrokes()
  }

  var isInTouchMode: Bool {
    isPointerLocked
//    !isClicked && isPointerLocked
  }

  
  public func handleCommand(_ command: DrawingCommand) {
    switch command {
      case .lockPointer:
//        print("Ran `lockPointer` command")
        isPointerLocked.toggle()
        
      case .clearCanvas:
//        print("Ran `clearCanvas` command")
        clearStrokes()
    }
  }
}
