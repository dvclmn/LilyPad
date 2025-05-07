//
//  Model+StrokeWidth.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation
import MemberwiseInit

//@MemberwiseInit(.public)
//public struct PointConfig: Codable, Equatable {
//  public var minDistance: CGFloat = 2
//  public var minSpeedForDenseSampling: CGFloat = 10
//}
//
//@MemberwiseInit(.public)
//public struct StrokeConfig: Codable, Equatable {
//  public var velocitySensitivity: CGFloat = 0.5
//  public var minWidth: CGFloat = 1.0
//  public var maxWidth: CGFloat = 100
//  
//  /// Speed at which the stroke is fully thinned
//  /// Directly ties the speed input to the visual outcome (width thinning)
//  public var maxThinningSpeed: CGFloat = 3.0
//}



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
    strokeConfig: StrokeConfig,
  ) -> CGFloat {
    let rawWidth: CGFloat
    
    /// Calculate raw width (existing logic)
    let velocityPart: CGFloat
    if let s = speed {
      let clampedSpeed = min(max(s, 0), strokeConfig.maxThinningSpeed)
      let t = clampedSpeed / strokeConfig.maxThinningSpeed
      let adjustedT = pow(t, strokeConfig.velocitySensitivity * 2)
      velocityPart = strokeConfig.maxWidth - (strokeConfig.maxWidth - strokeConfig.minWidth) * adjustedT
    } else {
      velocityPart = strokeConfig.maxWidth
    }
    
    let pressurePart: CGFloat
    if let p = pressure {
      let clamped = max(0, min(p, 1))
      let adjustedP = pow(clamped, pressureExponent)
      pressurePart = strokeConfig.minWidth + (strokeConfig.maxWidth - strokeConfig.minWidth) * adjustedP
    } else {
      pressurePart = strokeConfig.maxWidth
    }
    rawWidth = velocityPart * (1 - pressureWeight) + pressurePart * pressureWeight
    
    return rawWidth

  }
}
