//
//  Model+Zoom.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

struct ZoomGestureState: GestureTrackable {
  var angle: CGFloat
  var startAngle: CGFloat?
  var isActive = false

  mutating func update(touches: TouchPositions, phase: GesturePhase) {
    guard touches.count == 2 else { return }
    
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
