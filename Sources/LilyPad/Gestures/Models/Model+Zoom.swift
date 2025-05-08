//
//  Model+Zoom.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation


struct ZoomGestureState: GestureTrackable {
//  typealias GestureValue = CGFloat
  
  var scale: CGFloat = 1.0
  var startValue: CGFloat?
  var isActive = false
  var requiredTouchCount: Int { return 2 }
  
  mutating func update(event: TouchEventData, in rect: CGRect) {
    guard event.touches.count == requiredTouchCount else {
//      print("ZoomGesture requires exactly \(requiredTouchCount) touches")
      return
    }
    let positions = TouchPositions.mapped(from: event.touches, to: rect)
    
    switch event.phase {
      case .began:
        startValue = positions.distanceBetween
//        scale = 1.0
        isActive = true
        
      case .moved:
        
        guard let start = startValue else {
//          print("ZoomGesture: No value found for `startDistance`")
          return
        }
        scale = positions.distanceBetween / start
        
      case .ended, .cancelled, .none:
        isActive = false
        startValue = nil
    }
  }
}
