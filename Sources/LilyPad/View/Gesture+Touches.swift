//
//  Touches.swift
//  LilyPad
//
//  Created by Dave Coleman on 27/11/2024.
//

import AppKit

extension GestureView {
  
  func handleTouches(with event: NSEvent) {
    let touches = event.touches(matching: .touching, in: self)
    let trackpadTouches = Set(touches.map(TrackPadTouch.init))
    
    delegate?.didUpdateTouches(trackpadTouches)
    
    if touches.count == 2 {
      
      let touchesArray = Array(touches)
      
      if initialTouchDistance == nil {
        let touch1 = touchesArray[0].normalizedPosition
        let touch2 = touchesArray[1].normalizedPosition
        
        initialTouchDistance = hypot(touch2.x - touch1.x, touch2.y - touch1.y)
        initialTouchAngle = atan2(touch2.y - touch1.y, touch2.x - touch1.x)
        gestureStartTime = event.timestamp
      }
      
//      handleCombinedGesture(touchesArray)
      handleRotationFromTouches(touchesArray)
      
//      let touchesArray = Array(touches)
//      handleZoomFromTouches(touchesArray)
//      handleRotationFromTouches(touchesArray)
    } else {
//      previousTouchDistance = nil
//      previousTouchAngle = nil
      
      resetGestureState()
    }
  }
  
  public override func touchesBegan(with event: NSEvent) {
    handleTouches(with: event)
  }
  
  public override func touchesMoved(with event: NSEvent) {
    handleTouches(with: event)
  }
  
  public override func touchesEnded(with event: NSEvent) {
    handleTouches(with: event)
    previousTouchDistance = nil
  }
  
  public override func touchesCancelled(with event: NSEvent) {
    handleTouches(with: event)
    previousTouchDistance = nil
  }
  
  
//  private func handleCombinedGesture(_ touches: [NSTouch]) {
//    let touch1 = touches[0].normalizedPosition
//    let touch2 = touches[1].normalizedPosition
//    
//    /// Current state
//    let currentDistance = hypot(touch2.x - touch1.x, touch2.y - touch1.y)
//    let currentAngle = atan2(touch2.y - touch1.y, touch2.x - touch1.x)
//    
//    guard let initialDistance = initialTouchDistance,
//          let initialAngle = initialTouchAngle else { return }
//    
//    /// Calculate relative changes
//    let distanceChange = abs(currentDistance - initialDistance) / initialDistance
//    let angleChange = abs(angleDifference(currentAngle, initialAngle))
//    
//    /// Determine gesture dominance
//    let rotationThreshold: CGFloat = 0.1  // in radians
//    let zoomThreshold: CGFloat = 0.1      // 10% change
//    
//    let isSignificantRotation = angleChange > rotationThreshold
//    let isSignificantZoom = distanceChange > zoomThreshold
//    
//    /// Apply gestures based on dominance
//    if isSignificantRotation && (!isSignificantZoom || angleChange > distanceChange) {
//      handleRotation(currentAngle)
//    }
//    
//    if isSignificantZoom && (!isSignificantRotation || distanceChange > angleChange) {
//      handleZoom(currentDistance)
//    }
//    
//    previousTouchDistance = currentDistance
//    previousTouchAngle = currentAngle
//  } // END combined bgesture
  


}
