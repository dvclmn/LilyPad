////
////  StrokeHandler.swift
////  LilyPad
////
////  Created by Dave Coleman on 3/5/2025.
////
//
//import SwiftUI
//
//
//
//@Observable
///// Builds and manages stroke paths based on trackpad touches
//final public class StrokePathBuilder {
//  
//  
//
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
//  /// Current stroke color
//  private var currentColor: Color = .blue
//  
////  /// Update the base stroke width
////  public func setBaseStrokeWidth(_ width: CGFloat) {
////    baseStrokeWidth = width
////    maxStrokeWidth = width * 3
////    minStrokeWidth = width * 0.5
////  }
////  
////  /// Set the current stroke color
////  public func setCurrentColor(_ color: Color) {
////    currentColor = color
////  }
////  
//  
//  
////  /// Calculate stroke width based on touch velocity
////  private func calculateStrokeWidth(for touch: TrackpadTouch) -> CGFloat {
////    let speed = touch.speed
////    
////    // Inverse relationship: faster movement = thinner line
////    // Clamp within min and max stroke width
////    if speed <= 0.001 {
////      return maxStrokeWidth
////    } else if speed >= maxSpeedForMinWidth {
////      return minStrokeWidth
////    } else {
////      // Linear interpolation between max and min width based on speed
////      let speedFactor = speed / maxSpeedForMinWidth
////      return maxStrokeWidth - (maxStrokeWidth - minStrokeWidth) * speedFactor
////    }
////  }
//  
//  /// Generate a random color for new strokes
//  private func randomColor() -> Color {
//    // Use the current color instead of random
//    return currentColor
//  }
//  
//  /// Get all current strokes (active and completed)
//  public var allStrokes: [TouchStroke] {
//    return Array(activeStrokes.values) + completedStrokes
//  }
//  
//  /// Clear all strokes
//  public func clearStrokes() {
//    activeStrokes.removeAll()
//    completedStrokes.removeAll()
//  }
//  
//  
//}
