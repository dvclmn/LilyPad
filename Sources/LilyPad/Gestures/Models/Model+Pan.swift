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
//  var lastPositions: TouchPositions?
  var lastPanAmount: CGPoint = .zero
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
//        offset = .zero
        lastPanAmount = offset
        isActive = true
        
      case .moved:
        guard let start = startPositions else { return }
        
        let delta = positions.midPoint - start.midPoint
        let deltaDistance = abs(positions.distanceBetween - start.distanceBetween)
        
        offset = lastPanAmount + delta
        
      case .ended, .cancelled:
        isActive = false
        startPositions = nil
    }
  }
}

/// Consider making update(...) return something (e.g., a PanGestureUpdate struct),
/// so the state logic stays cleanly decoupled from usage.
struct PanGestureUpdate {
  var offset: CGPoint
  var velocity: CGPoint
}
