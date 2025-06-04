//
//  Gesture+Interpreter.swift
//  LilyPad
//
//  Created by Dave Coleman on 4/6/2025.
//

import BaseHelpers
import Foundation

public struct GestureRecogniser {

 // ~6 degrees

  /// How often, and when will this be called?
  func interpretGesture(
    from touches: [MappedTouchPoint],
    lastTouchPair: TouchPair
  ) throws -> GestureType {

    guard let currentouchPair = TouchPair(touches) else { throw GestureError.touchesNotEqualToTwo }

    let deltaPan = currentouchPair.midPointBetween - lastTouchPair.midPointBetween
    let deltaZoom = abs(currentouchPair.distanceBetween - lastTouchPair.distanceBetween)
    let deltaAngle = abs(currentouchPair.angleInRadiansBetween - lastTouchPair.angleInRadiansBetween)

    

  }


}

enum GestureError: Error, LocalizedError {
  case touchesNotEqualToTwo
}
