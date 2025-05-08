//
//  Model+Rotate.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

struct RotateGestureState: GestureTrackable {

  var angle: CGFloat = 1.0
  var startValue: CGFloat?
  var isActive = false
  
  var requiredTouchCount: Int { return 2 }

  mutating func update(event: TouchEventData, in rect: CGRect) {
    guard event.touches.count == requiredTouchCount else {
      print("RotateGesture requires exactly \(requiredTouchCount) touches")
      return
    }
    let positions = TouchPositions.mapped(from: event.touches, to: rect)
    let currentAngle = positions.angle

    switch event.phase {
      case .began:
        startValue = currentAngle
        angle = 1.0
        isActive = true

      case .moved:
        guard let start = startValue else {
          print("RotateGesture: No value found for `startAngle`")
          return
        }
        angle = currentAngle / start

      case .ended, .cancelled, .none:
        isActive = false
        startValue = nil
    }

  }
}
