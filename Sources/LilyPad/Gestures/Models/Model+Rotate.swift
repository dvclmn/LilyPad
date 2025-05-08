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
  
  mutating func update(event: TouchEventData, in rect: CGRect) {
    guard event.touches.count == requiredTouchCount else { return }
    let positions = TouchPositions.mapped(from: event.touches, to: rect)
    
    let currentAngle = positions.angle
    
    switch event.phase {
      case .began:
        startAngle = currentAngle
        angle = 1.0
        isActive = true
        
      case .moved:
        if let start = startAngle {
          angle = currentAngle / start
        }
      case .ended, .cancelled, .none:
        isActive = false
        startAngle = nil
    }
  }
}
