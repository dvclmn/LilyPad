//
//  StrokeHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI

public struct StrokeHandler {
  
  /// Active strokes being drawn, keyed by touch ID
  var activeStrokes: [Int: TouchStroke] = [:]
  
  /// Completed strokes
  var completedStrokes: [TouchStroke] = TouchStroke.exampleStrokes
  
  /// Stroke Width handler
  var strokeWidth = StrokeWidth(baseWidth: 6, sensitivity: 1.0)
  private var currentColor: Color = .blue
  
  /// Minimum number of points required to create a smooth curve
  let minPointsForCurve = 3
  
  /// Set the current stroke color
  public mutating func setCurrentColor(_ color: Color) {
    currentColor = color
  }
  
  /// Clear all strokes
  public mutating func clearStrokes() {
    activeStrokes.removeAll()
    completedStrokes.removeAll()
  }
  
  public init() {
  }
  
}

extension StrokeHandler {
  
  /// Current stroke color
  
  public var allStrokes: [TouchStroke] {
    return Array(activeStrokes.values) + completedStrokes
  }

}


public struct StrokeWidth {
  private var base: CGFloat
  private var sensitivity: CGFloat
  
  private var minWidth: CGFloat { base * 0.5 }
  private var maxWidth: CGFloat { base * 3 }
  
  public init(baseWidth: CGFloat, sensitivity: CGFloat) {
    self.base = baseWidth
    self.sensitivity = min(max(sensitivity, 0), 1) // Clamp 0...1
  }
  
  public func calculateStrokeWidth(for touch: TrackpadTouch) -> CGFloat {
    let clampedSpeed = min(max(touch.speed, 0), 3.0)
    let t = clampedSpeed / 3.0
    let adjustedT = pow(t, sensitivity * 2) // Exponential control curve
    return maxWidth - (maxWidth - minWidth) * adjustedT
  }
}




//struct StrokeWidth {
//  /// Base width for strokes
//  private var baseStrokeWidth: CGFloat = 10.0
//
//  /// Maximum width for strokes
//  private var maxStrokeWidth: CGFloat = 30.0
//
//  /// Minimum width for strokes
//  private var minStrokeWidth: CGFloat = 5.0
//
//  /// Speed at which stroke width is at its minimum
//  private var maxSpeedForMinWidth: CGFloat = 2.0
//
//
//  /// Update the base stroke width
//  public mutating func setBaseStrokeWidth(_ width: CGFloat) {
//    baseStrokeWidth = width
//    maxStrokeWidth = width * 3
//    minStrokeWidth = width * 0.5
//  }
//
//  /// Calculate stroke width based on touch velocity
//  public func calculateStrokeWidth(for touch: TrackpadTouch) -> CGFloat {
//    let speed = touch.speed
//
//    /// Inverse relationship: faster movement = thinner line
//    /// Clamp within min and max stroke width
//    if speed <= 0.001 {
//      return maxStrokeWidth
//    } else if speed >= maxSpeedForMinWidth {
//      return minStrokeWidth
//    } else {
//      /// Linear interpolation between max and min width based on speed
//      let speedFactor = speed / maxSpeedForMinWidth
//      return maxStrokeWidth - (maxStrokeWidth - minStrokeWidth) * speedFactor
//    }
//  }
//}
