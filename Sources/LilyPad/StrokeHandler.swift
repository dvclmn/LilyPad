//
//  StrokeHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI

/// Represents a touch stroke with a series of points and widths
public struct TouchStroke: Identifiable {
  public let id: UUID
  public var points: [CGPoint]
  public var widths: [CGFloat]
  public var color: Color
  
  public init(id: UUID = UUID(), points: [CGPoint] = [], widths: [CGFloat] = [], color: Color = .black) {
    self.id = id
    self.points = points
    self.widths = widths
    self.color = color
  }
  
  /// Add a point to the stroke with a specified width
  public mutating func addPoint(_ point: CGPoint, width: CGFloat) {
    points.append(point)
    widths.append(width)
  }
}

/// Builds and manages stroke paths based on trackpad touches
public struct StrokePathBuilder {
  /// Active strokes being drawn, keyed by touch ID
  private var activeStrokes: [Int: TouchStroke] = [:]
  
  /// Completed strokes
  private var completedStrokes: [TouchStroke] = []
  
  /// Minimum number of points required to create a smooth curve
  private let minPointsForCurve = 3
  
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
  
  /// Set the current stroke color
  public mutating func setCurrentColor(_ color: Color) {
    currentColor = color
  }
  
  /// Process touch updates and update strokes
  public mutating func processTouches(_ touches: Set<TrackpadTouch>) {
    // Process each touch to update strokes
    for touch in touches {
      let touchId = touch.id
      
      // Calculate width based on velocity
      let width = calculateStrokeWidth(for: touch)
      
      // Update or create stroke for this touch
      if var stroke = activeStrokes[touchId] {
        stroke.addPoint(touch.position, width: width)
        activeStrokes[touchId] = stroke
      } else {
        // New touch, create a new stroke
        var stroke = TouchStroke(color: randomColor())
        stroke.addPoint(touch.position, width: width)
        activeStrokes[touchId] = stroke
      }
    }
    
    // Check for ended touches
    let currentIds = Set(touches.map { $0.id })
    let activeIds = Set(activeStrokes.keys)
    let endedIds = activeIds.subtracting(currentIds)
    
    // Finalize ended strokes
    for touchId in endedIds {
      if let stroke = activeStrokes[touchId], stroke.points.count >= minPointsForCurve {
        completedStrokes.append(stroke)
      }
      activeStrokes.removeValue(forKey: touchId)
    }
  }
  
  /// Calculate stroke width based on touch velocity
  private func calculateStrokeWidth(for touch: TrackpadTouch) -> CGFloat {
    let speed = touch.speed
    
    // Inverse relationship: faster movement = thinner line
    // Clamp within min and max stroke width
    if speed <= 0.001 {
      return maxStrokeWidth
    } else if speed >= maxSpeedForMinWidth {
      return minStrokeWidth
    } else {
      // Linear interpolation between max and min width based on speed
      let speedFactor = speed / maxSpeedForMinWidth
      return maxStrokeWidth - (maxStrokeWidth - minStrokeWidth) * speedFactor
    }
  }
  
  /// Generate a random color for new strokes
  private func randomColor() -> Color {
    // Use the current color instead of random
    return currentColor
  }
  
  /// Get all current strokes (active and completed)
  public var allStrokes: [TouchStroke] {
    return Array(activeStrokes.values) + completedStrokes
  }
  
  /// Clear all strokes
  public mutating func clearStrokes() {
    activeStrokes.removeAll()
    completedStrokes.removeAll()
  }
  
  /// Generate a smooth path for a stroke using Catmull-Rom spline
  public func smoothPath(for stroke: TouchStroke) -> Path {
    guard stroke.points.count >= 2 else {
      // Not enough points for a path
      return Path()
    }
    
    if stroke.points.count == 2 {
      // Just a line for two points
      var path = Path()
      path.move(to: stroke.points[0])
      path.addLine(to: stroke.points[1])
      return path
    }
    
    // Use Catmull-Rom spline for smooth curves
    return catmullRomPath(for: stroke.points)
  }
  
  /// Create a Catmull-Rom spline path from points
  private func catmullRomPath(for points: [CGPoint]) -> Path {
    var path = Path()
    
    // Start at first point
    path.move(to: points[0])
    
    // Need at least 4 points for Catmull-Rom
    if points.count >= 4 {
      for i in 1..<points.count - 2 {
        let p0 = i > 0 ? points[i-1] : points[i]
        let p1 = points[i]
        let p2 = points[i+1]
        let p3 = i < points.count - 2 ? points[i+2] : points[i+1]
        
        // Add cubic curve using Catmull-Rom control points
        let controlPoint1 = CGPoint(
          x: p1.x + (p2.x - p0.x) / 6,
          y: p1.y + (p2.y - p0.y) / 6
        )
        
        let controlPoint2 = CGPoint(
          x: p2.x - (p3.x - p1.x) / 6,
          y: p2.y - (p3.y - p1.y) / 6
        )
        
        path.addCurve(to: p2, control1: controlPoint1, control2: controlPoint2)
      }
    } else {
      // Fallback for fewer points
      for i in 1..<points.count {
        path.addLine(to: points[i])
      }
    }
    
    return path
  }
}
