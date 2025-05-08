//
//  Model+Zoom.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

struct ZoomGestureState: GestureTrackable {
  var scale: CGFloat = 1.0
  var startDistance: CGFloat?
  var isActive = false
  
  let requiredTouchCount: Int = 2
  
  mutating func update(
    touches: Set<TouchPoint>,
    phase: GesturePhase,
    in rect: CGRect,
  ) {
    guard touches.count == requiredTouchCount else { return }
    let positions = TouchPositions.mapped(from: touches, to: destinationRect)
    
    let currentDistance = positions.distanceBetween
    
    switch phase {
      case .began:
        startDistance = currentDistance
        scale = 1.0
        isActive = true
      case .changed:
        if let start = startDistance {
          scale = currentDistance / start
        }
      case .ended, .cancelled:
        isActive = false
        startDistance = nil
    }
  }
}
