////
////  Model+Zoom.swift
////  LilyPad
////
////  Created by Dave Coleman on 8/5/2025.
////
//
//import Foundation
//
//struct ZoomGestureState: GestureTrackable {
//  typealias GestureValue = CGFloat
//  
//  var scale: CGFloat = 1.0
//  var startDistance: CGFloat?
//  var isActive = false
//  var defaultValue: GestureValue { .zero }
//  let requiredTouchCount: Int = 2
//  
//  mutating func update(event: TouchEventData, in rect: CGRect) -> GestureValue {
//    guard event.touches.count == requiredTouchCount else {
//      print("ZoomGesture requires exactly \(requiredTouchCount) touches")
//      return defaultValue
//    }
//    let positions = TouchPositions.mapped(from: event.touches, to: rect)
//    let currentDistance = positions.distanceBetween
//    
//    switch event.phase {
//      case .began:
//        startDistance = currentDistance
//        scale = 1.0
//        isActive = true
//        return currentDistance
//        
//      case .moved:
//        
//        guard let start = startDistance else {
//          print("ZoomGesture: No value found for `startDistance`")
//          return defaultValue
//        }
//        return currentDistance / start
//        
//      case .ended, .cancelled, .none:
//        isActive = false
//        startDistance = nil
//        return defaultValue
//    }
//  }
//}
