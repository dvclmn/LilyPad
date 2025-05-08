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
  
  let requiredTouchCount: Int = 2
  
  /// Not needed? May be useful to calculate some animation
  /// for inertia-based panning?
//  var lastVelocity: CGPoint
  
  mutating func update(
    touches: Set<TouchPoint>,
    phase: GesturePhase,
    in rect: CGRect,
  ) {
    
    guard touches.count == requiredTouchCount else { return }
    let positions = TouchPositions.mapped(from: touches, to: destinationRect)
    
    switch phase {
      case .began:
        startPositions = positions
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
