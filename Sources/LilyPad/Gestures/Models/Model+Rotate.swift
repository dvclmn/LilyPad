////
////  Model+Rotate.swift
////  LilyPad
////
////  Created by Dave Coleman on 8/5/2025.
////
//
//import Foundation
//
//struct RotateGestureState: GestureTrackable {
//
//  typealias GestureValue = CGFloat
//
//  var angle: CGFloat = 1.0
//  var startAngle: CGFloat?
//  var isActive = false
//
//  var defaultValue: GestureValue { .zero }
//  
//  let requiredTouchCount: Int = 2
//
//  mutating func update(event: TouchEventData, in rect: CGRect) -> GestureValue {
//    guard event.touches.count == requiredTouchCount else {
//      print("RotateGesture requires exactly \(requiredTouchCount) touches")
//      return defaultValue
//    }
//    let positions = TouchPositions.mapped(from: event.touches, to: rect)
//    let currentAngle = positions.angle
//
//    switch event.phase {
//      case .began:
//        startAngle = currentAngle
//        angle = 1.0
//        isActive = true
//        return defaultValue
//
//      case .moved:
//        guard let start = startAngle else {
//          print("RotateGesture: No value found for `startAngle`")
//          return defaultValue
//        }
//        return currentAngle / start
//
//      case .ended, .cancelled, .none:
//        isActive = false
//        startAngle = nil
//        return defaultValue
//    }
//
//  }
//}
