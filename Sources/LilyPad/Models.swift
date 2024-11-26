//
//  Model+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import AppKit

/// https://developer.apple.com/documentation/appkit/nsevent/eventtype/pressure
/// https://developer.apple.com/documentation/appkit/nsevent/phase-swift.property

@MainActor
public struct TrackpadGestureState {
  
  public var scrollDeltaX: CGFloat = 0
  public var scrollDeltaY: CGFloat = 0

  public var magnification: CGFloat = 1.0
  public var accumulatedMagnification: CGFloat = 1.0
  
  
  public var didPerformQuickLook: Bool = false
  
  /// Two-finger double tap on trackpads
  public var didPerformSmartMagnify: Bool = false
  
  public var rotation: CGFloat = 0
  
  public var phase: NSEvent.Phase = []
  
  public var effectiveMagnification: CGFloat {
    isGestureInProgress ? (accumulatedMagnification * magnification) : accumulatedMagnification
  }
  
  public var isGestureInProgress: Bool {
    phase.contains(.changed) || phase.contains(.ended)
  }

  public init() {}
  
  public func getValue(
    for gesture: GestureType,
    with sensitivity: Double,
    in range: ClosedRange<Double>
  ) -> Double {
    
    let baseValue: Double = self[keyPath: gesture.keyPath]
    
    let result: Double
    
    if gesture == .rotation {
      result = baseValue * .pi * 2
    } else {
      result = baseValue
    }
    
    let adjustedResult = result.clamped(to: range) * sensitivity
    
    return adjustedResult

  }
}

public enum GestureType {
  case scrollX
  case scrollY
  case magnification
  case rotation
  
  var keyPath: WritableKeyPath<TrackpadGestureState, CGFloat> {
    switch self {
      case .scrollX: \.scrollDeltaX
      case .scrollY: \.scrollDeltaY
      case .magnification: \.accumulatedMagnification
      case .rotation: \.rotation
    }
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

extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    min(max(self, limits.lowerBound), limits.upperBound)
  }
}
