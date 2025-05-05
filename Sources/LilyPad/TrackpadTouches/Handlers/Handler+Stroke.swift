//
//  StrokeHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI

public struct StrokeHandler {
  
  var isInTouchMode:
  
  var touches: Set<TrackpadTouch> = []
  
  /// Active strokes being drawn, keyed by touch ID
  var activeStrokes: [Int: TouchStroke] = [:]
  
  /// Completed strokes
  var completedStrokes: [TouchStroke] = []
  
  /// Stroke Width handler
//  var strokeWidth = StrokeWidth(baseWidth: 6, sensitivity: 1.0)
  
//  private var currentColor: Color = .blue
  
  /// Minimum number of points required to create a smooth curve
  let minPointsForCurve = 3
  
  /// Set the current stroke color
//  public mutating func setCurrentColor(_ color: Color) {
//    currentColor = color
//  }
  
  /// Clear all strokes
  public mutating func clearStrokes() {
    activeStrokes.removeAll()
    completedStrokes.removeAll()
  }
  
  public init() {
  }
}

extension StrokeHandler {
  
  public var allStrokes: [TouchStroke] {
    return Array(activeStrokes.values) + completedStrokes
  }

  /// Process touch updates and update strokes
  public func processTouches() {
    //    let timeStarted = Date.timeIntervalBetween1970AndReferenceDate
    //    print("Running `processTouches`")
    
    guard isInTouchMode else {
      print("No need to process touches, not in touch mode.")
      return
    }
    for touch in touches {
      let touchId = touch.id
      let touchPosition = touchPosition(touch)
      let velocity = touch.speed
      
      let width = strokeEngine.calculateWidth(for: touch)
      
      if var stroke = strokeHandler.activeStrokes[touchId] {
        if let last = stroke.points.last {
          let shouldAdd = strokeEngine.shouldAddPoint(from: last, to: touchPosition, velocity: velocity)
          if shouldAdd {
            stroke.addPoint(touchPosition, width: width)
          }
        } else {
          stroke.addPoint(touchPosition, width: width)
        }
        strokeHandler.activeStrokes[touchId] = stroke
      } else {
        /// First point for new stroke
        let stroke = TouchStroke(
          points: [touchPosition],
          widths: [width],
          color: .purple
        )
        strokeHandler.activeStrokes[touchId] = stroke
      }
    }
    
    // Finalize ended strokes
    let currentIds = Set(touches.map { $0.id })
    let activeIds = Set(strokeHandler.activeStrokes.keys)
    let endedIds = activeIds.subtracting(currentIds)
    
    for touchId in endedIds {
      if let stroke = strokeHandler.activeStrokes[touchId],
         stroke.points.count >= strokeHandler.minPointsForCurve
      {
        strokeHandler.completedStrokes.append(stroke)
      }
      strokeHandler.activeStrokes.removeValue(forKey: touchId)
    }
    
    //    let timeEnded = Date.timeIntervalBetween1970AndReferenceDate
    //
    //    let timeElapsed = timeEnded - timeStarted
    //    print("Time taken to process touches: \(timeElapsed) seconds")
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
