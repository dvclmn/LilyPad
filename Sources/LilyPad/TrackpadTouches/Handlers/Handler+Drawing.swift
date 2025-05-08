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

}

extension DrawingHandler {
  
  
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
        isPointerLocked.toggle()
      case .clearCanvas:
        clearStrokes()
    }
  }
}
