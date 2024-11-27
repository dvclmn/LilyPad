//
//  Gesture+Rotation.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import AppKit

extension GestureDetectingView {
  
  func handleRotationFromTouches(_ touches: [NSTouch]) {
    
    guard touches.count == 2 else { return }
    
    let touch1 = touches[0].normalizedPosition
    let touch2 = touches[1].normalizedPosition
    
    /// Calculate angle between touches
    let angle = atan2(touch2.y - touch1.y, touch2.x - touch1.x)
    
    if let previousTouchAngle {
      
      var delta = angle - previousTouchAngle
      
      /// Normalize delta to -π...π range
      if delta > .pi {
        delta -= .pi * 2
      } else if delta < -.pi {
        delta += .pi * 2
      }
      
      /// Get current state
      let currentState = states[.rotation] ?? TrackpadGestureState()
      
      /// Calculate new total rotation
      let newTotal = currentState.total + delta
      
      /// Update gesture state
      updateGesture(.rotation, delta: newTotal - currentState.total)
    }
    
    previousTouchAngle = angle
  }
  
//  func applyRotationSnapping(_ rotation: CGFloat) -> CGFloat {
//    for snapPoint in rotationSnapPoints {
//      let distance = abs(rotation - snapPoint.angle)
//      if distance < snapPoint.threshold {
//        // Apply snapping with strength factor
//        return rotation + (snapPoint.angle - rotation) * snapPoint.strength
//      }
//    }
//    return rotation
//  }
}
