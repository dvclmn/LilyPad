//
//  Model+Rotate.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

struct RotateGestureState: GestureTrackable {
  var angle: CGFloat = 1.0
  var startAngle: CGFloat?
  var isActive = false
  
  let requiredTouchCount: Int = 2
  
  mutating func update(
    touches: Set<TouchPoint>,
    phase: GesturePhase,
    in rect: CGRect,
//    spaces: MappingSpaces
  ) {
    guard touches.count == requiredTouchCount else { return }
    let positions = TouchPositions.mapped(from: touches, to: destinationRect)
    
    let currentAngle = touches.angle
    
    switch phase {
      case .began:
        startDistance = currentAngle
        angle = 1.0
        isActive = true
        
      case .changed:
        if let start = startAngle {
          angle = currentAngle / start
        }
      case .ended, .cancelled:
        isActive = false
        startAngle = nil
    }
  }
}
