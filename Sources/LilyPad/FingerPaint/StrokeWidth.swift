//
//  StrokeHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI

struct StrokeHandler {
  
  /// Active strokes being drawn, keyed by touch ID
  private var activeStrokes: [Int: TouchStroke] = [:]
  
  /// Completed strokes
  private var completedStrokes: [TouchStroke] = TouchStroke.exampleStrokes
  
  /// Minimum number of points required to create a smooth curve
  private let minPointsForCurve = 3
  
  public var allStrokes: [TouchStroke] {
    return Array(activeStrokes.values) + completedStrokes
  }
  
  
  /// Stroke Width handler
//  var strokeWidth = StrokeWidth()
}

struct StrokeWidth {
  /// Base width for strokes
  private var baseStrokeWidth: CGFloat = 10.0

  /// Maximum width for strokes
  private var maxStrokeWidth: CGFloat = 30.0

  /// Minimum width for strokes
  private var minStrokeWidth: CGFloat = 5.0

  /// Speed at which stroke width is at its minimum
  private var maxSpeedForMinWidth: CGFloat = 2.0

  /// Current stroke color
  private var currentColor: Color = .blue

  /// Update the base stroke width
  public mutating func setBaseStrokeWidth(_ width: CGFloat) {
    baseStrokeWidth = width
    maxStrokeWidth = width * 3
    minStrokeWidth = width * 0.5
  }

  /// Calculate stroke width based on touch velocity
  private func calculateStrokeWidth(for touch: TrackpadTouch) -> CGFloat {
    let speed = touch.speed

    /// Inverse relationship: faster movement = thinner line
    /// Clamp within min and max stroke width
    if speed <= 0.001 {
      return maxStrokeWidth
    } else if speed >= maxSpeedForMinWidth {
      return minStrokeWidth
    } else {
      /// Linear interpolation between max and min width based on speed
      let speedFactor = speed / maxSpeedForMinWidth
      return maxStrokeWidth - (maxStrokeWidth - minStrokeWidth) * speedFactor
    }
  }

}
