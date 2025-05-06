//
//  Model+StrokeWidth.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct StrokeWidthHandler {
  
  /// Note: This may need to be clamped, i.e.
  /// `self.sensitivity = min(max(sensitivity, 0), 1)`
  public var sensitivity: CGFloat = 0.5
  public var minWidth: CGFloat = 1.0
  public var maxWidth: CGFloat = 100
  
  /// Speed at which the stroke is fully thinned
  /// Directly ties the speed input to the visual outcome (width thinning)
  public var maxThinningSpeed: CGFloat = 3.0
  
  /// Maximum allowed change in width between consecutive points (as percentage of current width)
  /// Set to nil to disable width smoothing
  public var maxWidthChangePercentage: CGFloat? = 0.2 // 20% max change
  
  /// Previous width for smoothing calculations
  @Init(.ignore) private var previousWidth: CGFloat?
  @Init(.ignore) private var widthSamples: [CGFloat] = []
  @Init(.ignore) private let maxSamples = 3
  
  
  /// 0 = ignore pressure, 1 = pressure-only
  public var pressureWeight: CGFloat = 0.5
  
  /// for non-linear control of pressure effect
  public var pressureExponent: CGFloat = 1.0

  public mutating func calculateStrokeWidth(
    speed: CGFloat?,
    pressure: CGFloat?
  ) -> CGFloat {
    let rawWidth: CGFloat
    
    /// Calculate raw width (existing logic)
    let velocityPart: CGFloat
    if let s = speed {
      let clampedSpeed = min(max(s, 0), maxThinningSpeed)
      let t = clampedSpeed / maxThinningSpeed
      let adjustedT = pow(t, sensitivity * 2)
      velocityPart = maxWidth - (maxWidth - minWidth) * adjustedT
    } else {
      velocityPart = maxWidth
    }
    
    let pressurePart: CGFloat
    if let p = pressure {
      let clamped = max(0, min(p, 1))
      let adjustedP = pow(clamped, pressureExponent)
      pressurePart = minWidth + (maxWidth - minWidth) * adjustedP
    } else {
      pressurePart = maxWidth
    }
    
    rawWidth = velocityPart * (1 - pressureWeight) + pressurePart * pressureWeight
    
    widthSamples.append(rawWidth)
    if widthSamples.count > maxSamples {
      widthSamples.removeFirst()
    }
    let averagedWidth = widthSamples.reduce(0, +) / CGFloat(widthSamples.count)
    
    /// Apply width smoothing if enabled
    guard let maxChange = maxWidthChangePercentage, maxChange > 0 else {
      previousWidth = averagedWidth
      return max(0.001, averagedWidth)
    }
    
    if let previous = previousWidth {
      let minAllowed = previous * (1 - maxChange)
      let maxAllowed = previous * (1 + maxChange)
      let smoothedWidth = min(max(averagedWidth, minAllowed), maxAllowed)
      previousWidth = smoothedWidth
      return max(0.001, smoothedWidth)
    } else {
      previousWidth = averagedWidth
      return max(0.001, averagedWidth)
    }
  }
}
