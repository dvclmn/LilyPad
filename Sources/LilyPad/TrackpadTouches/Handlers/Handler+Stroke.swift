//
//  StrokeHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI
import BaseHelpers

public struct StrokeHandler {

  public var engine = StrokeEngine()

  private var canvasSize: CGSize

  public var touches: Set<TrackpadTouch> = []

  /// Active strokes being drawn, keyed by touch ID
  var activeStrokes: [Int: TouchStroke] = [:]

  /// Completed strokes
  var completedStrokes: [TouchStroke] = []

  /// Minimum number of points required to create a smooth curve
  let minPointsForCurve = 3

  /// Clear all strokes
  public mutating func clearStrokes() {
    activeStrokes.removeAll()
    completedStrokes.removeAll()
  }

  public mutating func updatecanvasSize(_ size: CGSize) {
    canvasSize = size
  }

  public init(canvasSize: CGSize) {
    print("`StrokeHandler` created at \(Date.now.format(.timeDetailed))")
    self.canvasSize = canvasSize
  }
}

extension StrokeHandler {

  public var allStrokes: [TouchStroke] {
    return Array(activeStrokes.values) + completedStrokes
  }

  /// Process touch updates and update strokes
  public mutating func processTouches() {

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
        activeStrokes[touchId] = stroke
      } else {
        /// First point for new stroke
        let stroke = TouchStroke(points: [strokePointPosition], colour: .purple)
        activeStrokes[touchId] = stroke
      }
    }

    /// Finalize ended strokes
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
  }

}
