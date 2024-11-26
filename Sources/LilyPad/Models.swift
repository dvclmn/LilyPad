//
//  Model+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import AppKit

/// https://developer.apple.com/documentation/appkit/nsevent/eventtype/pressure
/// https://developer.apple.com/documentation/appkit/nsevent/phase-swift.property

public struct TrackpadGestureState {
  
  var scrollDeltaX: CGFloat = 0
  var scrollDeltaY: CGFloat = 0
  
  var magnification: CGFloat = 1.0
  var accumulatedMagnification: CGFloat = 1.0
  
  
  var didPerformQuickLook: Bool = false
  
  /// Two-finger double tap on trackpads
  var didPerformSmartMagnify: Bool = false
  
  var rotation: CGFloat = 0
  
  var pressure: CGFloat = 0
  
  var phase: NSEvent.Phase = []
  
  var effectiveMagnification: CGFloat {
    isGestureInProgress ? (accumulatedMagnification * magnification) : accumulatedMagnification
  }
  
  var isGestureInProgress: Bool {
    phase.contains(.changed) || phase.contains(.ended)
  }

  
  func getValue(
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

enum GestureType {
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

extension NSEvent.Phase {
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
