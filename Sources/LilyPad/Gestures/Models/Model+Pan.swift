//
//  Model+Pan.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation
import BaseHelpers

struct PanGestureState: GestureTrackable {
  
  typealias GestureValue = CGPoint
  
  var offset: CGPoint = .zero
  var startPositions: TouchPositions?
//  var lastPositions: TouchPositions?
  var lastPanAmount: CGPoint = .zero
  var isActive = false
  
  var defaultValue: GestureValue { .zero }
  
  var requiredTouchCount: Int { return 2 }
  
  /// Not needed? May be useful to calculate some animation
  /// for inertia-based panning?
//  var lastVelocity: CGPoint
  
  mutating func update(event: TouchEventData, in rect: CGRect) -> GestureValue {
    
//    var newState = self
    
    guard event.touches.count == requiredTouchCount else {
      print("PanGesture requires exactly \(requiredTouchCount) touches")
      return .zero
    }
    let positions = TouchPositions.mapped(from: event.touches, to: rect)
    
    switch event.phase {
      case .began:
        startPositions = positions
//        offset = .zero
        lastPanAmount = offset
        isActive = true
        return lastPanAmount
        
      case .moved:
        guard let start = startPositions else {
          print("Not sure if this is right")
          return defaultValue
        }
        
        let delta = positions.midPoint - start.midPoint
//        let deltaDistance = abs(positions.distanceBetween - start.distanceBetween)
        
//        if deltaDistance > zoomThreshold {
          //          let scaleChange = currentPair.distanceBetween / start.distanceBetween
          //          store.scale = lastScale * scaleChange
          //        } else {
          //          // Don't update scale if zoom motion is below threshold
          //          store.scale = lastScale
          //        }
        
        let result = lastPanAmount + delta
        return result
        
      case .ended, .cancelled, .none:
        isActive = false
        startPositions = nil
        return defaultValue
    }
    
  }
}

/// Consider making update(...) return something (e.g., a PanGestureUpdate struct),
/// so the state logic stays cleanly decoupled from usage.
struct PanGestureUpdate {
  var offset: CGPoint
  var velocity: CGPoint
}
