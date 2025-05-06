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
  
  
  
  /// 0 = ignore pressure, 1 = pressure-only
  public var pressureWeight: CGFloat = 0.5
  
  /// for non-linear control of pressure effect
  public var pressureExponent: CGFloat = 1.0

  public func calculateStrokeWidth(
    speed: CGFloat?,
    pressure: CGFloat?
  ) -> CGFloat {
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
    
    let blended = velocityPart * (1 - pressureWeight) + pressurePart * pressureWeight
    return max(0.001, blended)
  }
}
