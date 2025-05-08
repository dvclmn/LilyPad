//
//  Model+Pan.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

struct PanGestureState: GestureTrackable {
  var offset: CGPoint = .zero
  var startPositions: TouchPositions?
  var isActive = false
  /// Not needed?
//  var lastVelocity: CGPoint
  
  mutating func update(touches: TouchPositions, phase: GesturePhase) {
    switch phase {
      case .began:
        startPositions = touches
        offset = .zero
        isActive = true
      case .changed:
        if let start = startPositions {
          offset = touches.averagePoint() - start.averagePoint()
        }
      case .ended, .cancelled:
        isActive = false
        startPositions = nil
    }
  }
}
