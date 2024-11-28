//
//  Gesture+Pan.swift
//  LilyPad
//
//  Created by Dave Coleman on 27/11/2024.
//

import AppKit

extension GestureView {
  
  public override func scrollWheel(with event: NSEvent) {
    
    guard !event.scrollingDeltaX.isNaN && !event.scrollingDeltaY.isNaN else { return }
    
    updateGesture(.panX, delta: event.scrollingDeltaX)
    updateGesture(.panY, delta: event.scrollingDeltaY)
    
    /// Update phase for both pan gestures
    states[.panX]?.phase = event.phase
    states[.panY]?.phase = event.phase
    
  }
}
