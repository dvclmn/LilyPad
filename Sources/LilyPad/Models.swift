//
//  Model+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

/// https://developer.apple.com/documentation/appkit/nsevent/eventtype/pressure
/// https://developer.apple.com/documentation/appkit/nsevent/phase-swift.property


public struct GestureConfig {
  var range: ClosedRange<CGFloat>
  var sensitivity: CGFloat
  
  func normalize(_ value: CGFloat) -> CGFloat {
    /// Handle infinite ranges differently for pan gestures
    guard range.upperBound.isFinite && range.lowerBound.isFinite else {
      /// Some appropriate default for infinite ranges
      return 0.5
    }
    
    let result: CGFloat = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    
    return result.clamped(to: 0...1)
      
  }
}


public struct TrackpadGestureState {
  public var delta: CGFloat
  public var total: CGFloat
  public var phase: NSEvent.Phase
  
  public init(
    delta: CGFloat = 0,
    total: CGFloat = 0,
    phase: NSEvent.Phase = []
  ) {
    self.delta = delta
    self.total = total
    self.phase = phase
  }
}

public struct TrackPadTouch: Identifiable, Hashable {
  
  public var id: Int
  
  /// Normalized touch X position on a device (0.0 - 1.0).
  public let normalizedX: CGFloat
  
  /// Normalized touch Y position on a device (0.0 - 1.0).
  public let normalizedY: CGFloat
  
  public init(_ nsTouch: NSTouch) {
    self.normalizedX = nsTouch.normalizedPosition.x
    /// `NSTouch.normalizedPosition.y` is flipped -> 0.0 means bottom. But the
    /// `Touch` structure is meants to be used with the SwiftUI -> flip it.
    self.normalizedY = 1.0 - nsTouch.normalizedPosition.y
    self.id = nsTouch.hash
  }
  
  public init(x: CGFloat, y: CGFloat) {
    self.id = UUID().hashValue
    self.normalizedX = x
    self.normalizedY = 1.0 - y
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
        return GestureConfig(range: -(.pi*2)...(.pi*2), sensitivity: 1.0)
      case .panX, .panY:
        return GestureConfig(range: -CGFloat.infinity...CGFloat.infinity, sensitivity: 0.8)
    }
  }
  
  func updateState(_ currentState: TrackpadGestureState, delta: CGFloat, config: GestureConfig) -> TrackpadGestureState {
    var newState = currentState
    newState.delta = delta * config.sensitivity
    
    switch self {
      case .zoom:
        newState.total = (currentState.total * (1.0 + newState.delta)).clamped(to: config.range)
      case .rotation:
        newState.total = (currentState.total + newState.delta).clamped(to: config.range)
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

public extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    // Ensure the range is valid
    let validRange = min(limits.lowerBound, limits.upperBound)...max(limits.lowerBound, limits.upperBound)
    return min(max(self, validRange.lowerBound), validRange.upperBound)
  }
}
