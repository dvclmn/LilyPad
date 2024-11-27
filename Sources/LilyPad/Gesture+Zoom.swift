//
//  Gesture+Zoom.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import AppKit

extension GestureDetectingView {
  
  func handleZoomFromTouches(_ touches: [NSTouch]) {
    guard touches.count == 2 else { return }
    
    let touch1 = touches[0].normalizedPosition
    let touch2 = touches[1].normalizedPosition
    
    /// Calculate current distance between touches
    let currentDistance = hypot(
      touch2.x - touch1.x,
      touch2.y - touch1.y
    )
    
    if let previousTouchDistance {
      var delta = (currentDistance - previousTouchDistance) / previousTouchDistance
      
      /// Apply dampening for small changes
      //      let dampThreshold: CGFloat = 0.01
      //      if abs(delta) < dampThreshold {
      //        delta = 0
      //      }
      
      updateGesture(.zoom, delta: delta)
    }
    
    previousTouchDistance = currentDistance
  }
}
