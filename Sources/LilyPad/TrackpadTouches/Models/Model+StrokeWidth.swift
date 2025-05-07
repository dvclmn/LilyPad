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
  /// Maximum allowed change in width between consecutive points (as percentage of current width)
  /// Set to nil to disable width smoothing
  public var maxWidthChangePercentage: CGFloat? = 0.2 // 20% max change

  /// 0 = ignore pressure, 1 = pressure-only
  public var pressureWeight: CGFloat = 0.5
  
  /// for non-linear control of pressure effect
  public var pressureExponent: CGFloat = 1.0

  public func calculateStrokeWidth(
    speed: CGFloat?,
    pressure: CGFloat?,
    config: StrokeConfiguration,
  ) -> CGFloat {
    let rawWidth: CGFloat
    
    /// Calculate raw width (existing logic)
    let velocityPart: CGFloat
    if let s = speed {
      let clampedSpeed = min(max(s, 0), config.maxThinningSpeed)
      let t = clampedSpeed / config.maxThinningSpeed
      let adjustedT = pow(t, config.velocitySensitivity * 2)
      velocityPart = config.maxWidth - (config.maxWidth - config.minWidth) * adjustedT
    } else {
      velocityPart = config.maxWidth
    }
    
    let pressurePart: CGFloat
    if let p = pressure {
      let clamped = max(0, min(p, 1))
      let adjustedP = pow(clamped, pressureExponent)
      pressurePart = config.minWidth + (config.maxWidth - config.minWidth) * adjustedP
    } else {
      pressurePart = config.maxWidth
    }
    rawWidth = velocityPart * (1 - pressureWeight) + pressurePart * pressureWeight
    
    return rawWidth

  }
}
