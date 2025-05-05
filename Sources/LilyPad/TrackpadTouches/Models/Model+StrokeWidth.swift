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

  public func calculateStrokeWidth(for speed: CGFloat) -> CGFloat {
    let clampedSpeed = min(max(speed, 0), maxThinningSpeed)
    let t = clampedSpeed / maxThinningSpeed
    let adjustedT = pow(t, sensitivity * 2)  // Exponential control curve
    
    let result = max(0.001, (maxWidth - (maxWidth - minWidth) * adjustedT))
    return result
  }
}
