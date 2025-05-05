//
//  Model+StrokeWidth.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation

public struct StrokeWidthHandler {
  public var base: CGFloat
  public var sensitivity: CGFloat
  
  private var minWidth: CGFloat { base * 0.5 }
  private var maxWidth: CGFloat { base * 3 }
  
  public init(baseWidth: CGFloat = 10, sensitivity: CGFloat = 0.5) {
    print("`StrokeWidthHandler` created at \(Date.now.format(.timeDetailed))")
    self.base = baseWidth
    self.sensitivity = min(max(sensitivity, 0), 1) // Clamp 0...1
  }
  
  public func calculateStrokeWidth(for speed: CGFloat) -> CGFloat {
    let clampedSpeed = min(max(speed, 0), 3.0)
    let t = clampedSpeed / 3.0
    let adjustedT = pow(t, sensitivity * 2) // Exponential control curve
    return maxWidth - (maxWidth - minWidth) * adjustedT
  }
}
