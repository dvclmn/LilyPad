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
  public var totalRotation: CGFloat = 0
  private(set) var normalizedRotation: CGFloat = 0.5
  
  // Translation
  public var scrollDeltaX: CGFloat = 0
  public var scrollDeltaY: CGFloat = 0
  private(set) var totalTranslationX: CGFloat = 0
  private(set) var totalTranslationY: CGFloat = 0

  
  var phase: NSEvent.Phase = []
  
  // Configuration
  var config: TrackpadGestureConfig = .init()

  // Maximum rotation in radians (default ±2π, one full rotation)
  var maxRotation: CGFloat = .pi * 2
  
  mutating func updateMagnification(_ delta: CGFloat) {
    
    magnificationDelta = delta
    
    let newTotal = (totalMagnification * (1.0 + delta))
    
    totalMagnification = newTotal.clamped(to: config.minScale...config.maxScale)
    
    let range = config.maxScale - config.minScale
    guard range > 0 else {
      normalizedScale = 0.5
      return
    }
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
  
  
//  mutating func updateScroll(deltaX: CGFloat, deltaY: CGFloat) {
//    scrollDeltaX = deltaX * config.scrollSensitivity
//    scrollDeltaY = deltaY * config.scrollSensitivity
//    
//    totalTranslationX += scrollDeltaX
//    totalTranslationY += scrollDeltaY
//  }
  
  mutating func updateScroll(deltaX: CGFloat, deltaY: CGFloat) {
    guard !deltaX.isNaN && !deltaX.isInfinite &&
            !deltaY.isNaN && !deltaY.isInfinite else { return }
    
    scrollDeltaX = deltaX * config.scrollSensitivity
    scrollDeltaY = deltaY * config.scrollSensitivity
    
    let newX = totalTranslationX + scrollDeltaX
    let newY = totalTranslationY + scrollDeltaY
    
    guard !newX.isNaN && !newX.isInfinite &&
            !newY.isNaN && !newY.isInfinite else { return }
    
    totalTranslationX = newX
    totalTranslationY = newY
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

  public var isGestureInProgress: Bool {
    phase.contains(.changed) || phase.contains(.ended)
  }

  public init() {}
  
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



public struct TrackpadGestureConfig {
  
  private var _minScale: CGFloat
  private var _maxScale: CGFloat
  
  var minScale: CGFloat {
    get { _minScale }
    set { _minScale = max(0.0001, newValue) }
  }
  
  var maxScale: CGFloat {
    get { _maxScale }
    set { _maxScale = max(_minScale, newValue) }
  }
  

  var scrollSensitivity: CGFloat
  var rotationSensitivity: CGFloat
  var maxRotation: CGFloat
  
  public init(
    minScale: CGFloat = 0.1,
    maxScale: CGFloat = 10.0,
    scrollSensitivity: CGFloat = 1.0,
    rotationSensitivity: CGFloat = 0.005,
    maxRotation: CGFloat = .pi * 2
  ) {
    self._minScale = minScale
    self._maxScale = maxScale
    self.scrollSensitivity = scrollSensitivity
    self.rotationSensitivity = rotationSensitivity
    self.maxRotation = maxRotation
  }
}
