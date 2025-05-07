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
//    let velocityPart: CGFloat
//    if let s = speed {
//      let clampedSpeed = min(max(s, 0), config.maxThinningSpeed)
//      let t = clampedSpeed / config.maxThinningSpeed
//      let adjustedT = pow(t, config.velocitySensitivity * 2)
//      velocityPart = config.maxStrokeWidth - (config.maxStrokeWidth - config.minStrokeWidth) * adjustedT
//    } else {
//      velocityPart = config.maxStrokeWidth
//    }
//    
//    let pressurePart: CGFloat
//    if let p = pressure {
//      let clamped = max(0, min(p, 1))
//      let adjustedP = pow(clamped, pressureExponent)
//      pressurePart = config.minStrokeWidth + (config.maxStrokeWidth - config.minStrokeWidth) * adjustedP
//    } else {
//      pressurePart = config.maxStrokeWidth
//    }
    
    // Calculate velocity and pressure components using the helper
    let velocityPart = calculateWidthComponent(
      value: speed,
      minValue: 0,
      maxValue: config.maxThinningSpeed,
      exponent: config.velocitySensitivity * 2,
      inverse: true,
      config: config
    )
    
    let pressurePart = calculateWidthComponent(
      value: pressure,
      minValue: 0,
      maxValue: 1,
      exponent: pressureExponent,
      inverse: false,
      config: config
    )
    rawWidth = velocityPart * (1 - pressureWeight) + pressurePart * pressureWeight
    
    return rawWidth

  }
  
  /// Calculate width based on input factor
  func calculateWidthComponent(
    value: CGFloat?,
    minValue: CGFloat,
    maxValue: CGFloat,
    exponent: CGFloat,
    inverse: Bool = false,
    config: StrokeConfiguration
  ) -> CGFloat {
    guard let value = value else {
      return config.maxStrokeWidth
    }
    
    let clamped = min(max(value, minValue), maxValue)
    let normalized = (clamped - minValue) / (maxValue - minValue)
    let adjusted = pow(normalized, exponent)
    
    if inverse {
      // For velocity: higher value means thinner stroke
      return config.maxStrokeWidth - (config.maxStrokeWidth - config.minStrokeWidth) * adjusted
    } else {
      // For pressure: higher value means thicker stroke
      return config.minStrokeWidth + (config.maxStrokeWidth - config.minStrokeWidth) * adjusted
    }
  }
  
  
}
