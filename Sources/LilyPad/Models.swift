//
//  Model+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

/// https://developer.apple.com/documentation/appkit/nsevent/eventtype/pressure
/// https://developer.apple.com/documentation/appkit/nsevent/phase-swift.property

@MainActor
public struct TrackpadGestureState {
  
  
  // Magnification
  private(set) var magnificationDelta: CGFloat = 0
  private(set) var totalMagnification: CGFloat = 1.0
  private(set) var normalizedScale: CGFloat = 0.5
  
  // Rotation
  private(set) var rotationDelta: CGFloat = 0
  private(set) var totalRotation: CGFloat = 0
  private(set) var normalizedRotation: CGFloat = 0.5
  
  // Translation
  public var scrollDeltaX: CGFloat = 0
  public var scrollDeltaY: CGFloat = 0
  private(set) var totalTranslationX: CGFloat = 0
  private(set) var totalTranslationY: CGFloat = 0

  
  var phase: NSEvent.Phase = []
  
  // Configuration
  var config: TrackpadGestureConfig = .init()
//  var minScale: CGFloat = 0.1
//  var maxScale: CGFloat = 10.0
//  var scrollSensitivity: CGFloat = 1.0
//  var rotationSensitivity: CGFloat = 1.0
  
  // Maximum rotation in radians (default ±2π, one full rotation)
  var maxRotation: CGFloat = .pi * 2
  
  
  mutating func updateMagnification(_ delta: CGFloat) {
    magnificationDelta = delta
    
    // Update total magnification
    totalMagnification = (totalMagnification * (1.0 + delta))
      .clamped(to: config.minScale...config.maxScale)
    
    // Convert to normalized value (0...1)
    normalizedScale = ((totalMagnification - config.minScale) / (config.maxScale - config.minScale))
      .clamped(to: 0...1)
  }
  
  mutating func updateRotation(_ delta: CGFloat) {
    rotationDelta = delta * config.rotationSensitivity
    
    // Update total rotation, clamping to max range
    totalRotation = (totalRotation + rotationDelta)
      .clamped(to: -maxRotation...maxRotation)
    
    // Convert to normalized value (0...1)
    normalizedRotation = ((totalRotation + maxRotation) / (2 * maxRotation))
      .clamped(to: 0...1)
  }
  
  
  mutating func updateScroll(deltaX: CGFloat, deltaY: CGFloat) {
    scrollDeltaX = deltaX * config.scrollSensitivity
    scrollDeltaY = deltaY * config.scrollSensitivity
    
    totalTranslationX += scrollDeltaX
    totalTranslationY += scrollDeltaY
  }
  
  // Helper to get scale factor for SwiftUI
  public var scaleEffect: CGFloat {
    // Convert normalized scale back to useful range
    config.minScale + (normalizedScale * (config.maxScale - config.minScale))
  }
  
  public var rotationAngle: Angle {
    Angle(radians: Double(totalRotation))
  }
  
  // Reset all transformations
  mutating func reset() {
    totalMagnification = 1.0
    normalizedScale = 0.5
    totalRotation = 0
    normalizedRotation = 0.5
    totalTranslationX = 0
    totalTranslationY = 0
  }
  
//  public var scrollDeltaX: CGFloat = 0
//  public var scrollDeltaY: CGFloat = 0
//
//  public var magnification: CGFloat = 1.0
//  public var accumulatedMagnification: CGFloat = 1.0
//  
//  
//  public var didPerformQuickLook: Bool = false
//  
//  /// Two-finger double tap on trackpads
//  public var didPerformSmartMagnify: Bool = false
//  
//  public var rotation: CGFloat = 0
//  
//  public var phase: NSEvent.Phase = []
  
//  public var effectiveMagnification: CGFloat {
//    isGestureInProgress ? (accumulatedMagnification * magnification) : accumulatedMagnification
//  }
  
  public var isGestureInProgress: Bool {
    phase.contains(.changed) || phase.contains(.ended)
  }

  public init() {}
  
//  public func getValue(
//    for gesture: GestureType,
//    with sensitivity: Double,
//    in range: ClosedRange<Double>
//  ) -> Double {
//    
//    let baseValue: Double = self[keyPath: gesture.keyPath]
//    
//    let result: Double
//    
//    if gesture == .rotation {
//      result = baseValue * .pi * 2
//    } else {
//      result = baseValue
//    }
//    
//    let adjustedResult = result.clamped(to: range) * sensitivity
//    
//    return adjustedResult
//
//  }
}

//public enum GestureType {
//  case scrollX
//  case scrollY
//  case magnification
//  case rotation
//  
//  var keyPath: WritableKeyPath<TrackpadGestureState, CGFloat> {
//    switch self {
//      case .scrollX: \.scrollDeltaX
//      case .scrollY: \.scrollDeltaY
//      case .magnification: \.accumulatedMagnification
//      case .rotation: \.rotation
//    }
//  }
//  
//  
//}

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


public struct TrackpadGestureConfig {
  var minScale: CGFloat = 0.1
  var maxScale: CGFloat = 10.0
  var scrollSensitivity: CGFloat = 1.0
  var rotationSensitivity: CGFloat = 1.0
  var maxRotation: CGFloat = .pi * 2
  
  public init(
    minScale: CGFloat = 0.1,
    maxScale: CGFloat = 10.0,
    scrollSensitivity: CGFloat = 1.0,
    rotationSensitivity: CGFloat = 1.0,
    maxRotation: CGFloat = .pi * 2
  ) {
    self.minScale = minScale
    self.maxScale = maxScale
    self.scrollSensitivity = scrollSensitivity
    self.rotationSensitivity = rotationSensitivity
    self.maxRotation = maxRotation
  }
}
