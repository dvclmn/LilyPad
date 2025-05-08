//
//  Model+Rotate.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

struct RotateGestureState: GestureTrackable {
  var scale: CGFloat = 1.0
  var startDistance: CGFloat?
  var isActive = false
  
  mutating func update(touches: TouchPositions, phase: GesturePhase) {
    guard touches.count == 2 else { return }
    
    let currentDistance = touches.distanceBetweenFirstTwo()
    
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
