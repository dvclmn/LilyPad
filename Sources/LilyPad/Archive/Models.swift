//
//  Model+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI
import BaseHelpers

public struct GestureConfig {
  var range: ClosedRange<CGFloat>
  var sensitivity: CGFloat
}

/// Distance/angle between two fingers forming gesture
public struct CurrentGestureState {
  public var initialDistance: CGFloat
  public var initialAngle: CGFloat
  public var previousDistance: CGFloat
  public var previousAngle: CGFloat
}

public struct GestureState {
  public var delta: CGFloat = 0
  public var total: CGFloat = 0
  public var phase: NSEvent.Phase = []

}

public struct TrackPadTouch: Identifiable, Hashable {
  public var id: Int
  public let position: CGPoint
  
  public init(_ nsTouch: NSTouch) {
    self.id = nsTouch.hash
    self.position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      y: 1.0 - nsTouch.normalizedPosition.y
    )
  }
  
  public init(x: CGFloat, y: CGFloat) {
    self.id = UUID().hashValue
    self.position = CGPoint(x: x, y: 1.0 - y)
  }
}


public enum GestureType: CaseIterable {
  case zoom
  case rotation
  case panX
  case panY
  
  var defaultConfig: GestureConfig {
    switch self {
      case .zoom:
        return GestureConfig(range: 0.1...6.0, sensitivity: 1.0)
      case .rotation:
        return GestureConfig(range: -360...360, sensitivity: 1.0)
      case .panX, .panY:
        return GestureConfig(range: -CGFloat.infinity...CGFloat.infinity, sensitivity: 0.8)
    }
  }
  
  func updateState(
    _ currentState: GestureState,
    delta: CGFloat,
    config: GestureConfig
  ) -> GestureState {
    
    var newState = currentState
    newState.delta = delta * config.sensitivity
    
    switch self {
        
      case .zoom:
        newState.total = (currentState.total * (1.0 + newState.delta)).clamped(to: config.range)
        
      case .rotation:
        /// Add the delta to the total rotation
        let newTotal = currentState.total + newState.delta
        
        /// Normalize the total rotation to stay within the range
        if config.range.contains(newTotal) {
          newState.total = newTotal
        } else {
          newState.total = newTotal.clamped(to: config.range)
        }
        
      case .panX, .panY:
        newState.total = currentState.total + newState.delta
    }
    
    return newState
  }
  
  
  
}

public extension NSEvent.Phase {
  var name: String {
    switch self {
      case .began: "Began"
      case .changed: "Changed"
      case .ended: "Ended"
      case .mayBegin: "May begin"
      case .stationary: "Stationary"
      default: "No phase"
    }
  }
}



//extension CGFloat {
//  func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
//    max(range.lowerBound, min(range.upperBound, self))
//  }
//}
