//
//  Gesture+Rotation.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import AppKit

extension GestureView {
  
  func angleDifference(_ angle1: CGFloat, _ angle2: CGFloat) -> CGFloat {
    /// Flipping the rotation here, as this seems to yield the most appropriate behaviour in the UI
    var diff = -(angle1 - angle2)
    while diff > .pi { diff -= .pi * 2 }
    while diff < -.pi { diff += .pi * 2 }
    return diff
  }
  
  
//  func handleRotation(_ currentAngle: CGFloat) {
//    if let previousAngle = previousTouchAngle {
//      
//      let delta = angleDifference(currentAngle, previousAngle)
//      let deltaDegrees = delta * (180.0 / .pi)
//      let smoothedDelta = smoothValue(deltaDegrees, deltas: &recentRotationDeltas)
//      updateGesture(.rotation, delta: smoothedDelta)
//    }
//  }
  
  
  
//  func handleRotationFromTouches(_ touches: [NSTouch]) {
//    guard touches.count == 2 else {
//      previousTouchAngle = nil
//      return
//    }
//    
//    let touch1 = touches[0].normalizedPosition
//    let touch2 = touches[1].normalizedPosition
//    
//    // Calculate the current angle between the two touches
//    let currentAngle = atan2(touch2.y - touch1.y, touch2.x - touch1.x)
//    
//    if let previousAngle = previousTouchAngle {
//      // Calculate the shortest angular distance between the previous and current angles
//      var deltaAngle = currentAngle - previousAngle
//      
//      // Normalize the delta to be between -π and π
//      while deltaAngle > .pi {
//        deltaAngle -= .pi * 2
//      }
//      while deltaAngle < -.pi {
//        deltaAngle += .pi * 2
//      }
//      
//      // Convert to degrees for easier handling (optional)
//      let deltaDegrees = deltaAngle * (180.0 / .pi)
//      
//      // Update the gesture with the delta
//      updateGesture(.rotation, delta: deltaDegrees)
//    }
//    
//    previousTouchAngle = currentAngle
//  }
}
