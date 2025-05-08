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
  
  mutating func update(event: TouchEventData, in rect: CGRect) {
    guard event.touches.count == requiredTouchCount else { return }
    let positions = TouchPositions.mapped(from: event.touches, to: rect)
    
    let currentDistance = positions.distanceBetween
    
    switch event.phase {
      case .began:
        startDistance = currentDistance
        scale = 1.0
        isActive = true
      case .moved:
        if let start = startDistance {
          scale = currentDistance / start
        }
      case .ended, .cancelled, .none:
        isActive = false
        startDistance = nil
    }
  }
}
