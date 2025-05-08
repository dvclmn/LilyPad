//
//  Model+Pan.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation
import BaseHelpers

struct PanGestureState: GestureTrackable {
  var offset: CGPoint = .zero
  var startPositions: TouchPositions?
  var isActive = false
  
  var requiredTouchCount: Int { return 2 }
  
  /// Not needed? May be useful to calculate some animation
  /// for inertia-based panning?
//  var lastVelocity: CGPoint
  
  mutating func update(event: TouchEventData, in rect: CGRect) {
    
    guard event.touches.count == requiredTouchCount else { return }
    let positions = TouchPositions.mapped(from: event.touches, to: rect)
    
    switch event.phase {
      case .began:
        startPositions = positions
        offset = .zero
        isActive = true
      case .moved:
        if let start = startPositions {
          offset = positions.midPoint - start.midPoint
        }
      case .ended, .cancelled:
        isActive = false
        startPositions = nil
    }
  }
}
