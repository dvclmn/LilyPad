//
//  StrokeHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI

public struct StrokeHandler {

  var engine = StrokeEngine()

  private var canvasSize: CGSize

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

  public mutating func updatecanvasSize(_ size: CGSize) {
    canvasSize = size
  }

  public init(canvasSize: CGSize) {
    self.canvasSize = canvasSize
  }
}

extension StrokeHandler {

  public var allStrokes: [TouchStroke] {
    return Array(activeStrokes.values) + completedStrokes
  }

  /// Process touch updates and update strokes
  public mutating func processTouches() {
    //    let timeStarted = Date.timeIntervalBetween1970AndReferenceDate
    //    print("Running `processTouches`")

    //    guard isInTouchMode else {
    //      print("No need to process touches, not in touch mode.")
    //      return
    //    }

    guard canvasSize != .zero else {
      print("Canvas size cannot be zero, skipping touch processing.")
      return
    }
    for touch in touches {
      let touchId = touch.id
      let touchPosition = touch.position.convertNormalisedToConcrete(in: canvasSize)

      let timeStamp = touch.timestamp
      let speed = touch.velocity.speed

      let strokePointPosition = StrokePoint(
        position: touchPosition,
        timestamp: timeStamp,
        velocity: touch.velocity
      )

      let width = engine.calculateWidth(for: speed)

      if var stroke = activeStrokes[touchId] {
        if let last = stroke.points.last {
          let shouldAdd = engine.shouldAddPoint(
            from: last.position,
            to: touchPosition,
            speed: speed
          )
          if shouldAdd {
            stroke.addPoint(strokePointPosition)
          }
        }
        //        else {
        //          stroke.addPoint(touchPosition, width: width)
        //        }
        activeStrokes[touchId] = stroke
      } else {
        /// First point for new stroke
        let stroke = TouchStroke(points: [strokePointPosition], colour: .purple)
        activeStrokes[touchId] = stroke
      }
    }

    // Finalize ended strokes
    let currentIds = Set(touches.map { $0.id })
    let activeIds = Set(activeStrokes.keys)
    let endedIds = activeIds.subtracting(currentIds)

    for touchId in endedIds {
      if let stroke = activeStrokes[touchId],
        stroke.points.count >= minPointsForCurve
      {
        completedStrokes.append(stroke)
      }
      activeStrokes.removeValue(forKey: touchId)
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
