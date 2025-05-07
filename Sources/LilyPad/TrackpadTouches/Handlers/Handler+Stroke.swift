//
//  StrokeHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import BaseHelpers
import SwiftUI
import MemberwiseInit
import BaseStyles



@MemberwiseInit(.public)
public struct Artwork: Codable, Equatable {
  public var canvasSize: CGSize = .init(width: 700, height: 438)
  public var completedStrokes: [TouchStroke] = []
  public var preferences: Preferences?
  
  public static let `default` = Artwork()
}


public struct StrokeHandler {

  public var engine = StrokeEngine()

  public var artwork = Artwork()
  
  /// The number of fingers touching the trackpad
  /// Inadvertant touches may be made by a palm etc as well.
  public var touches: Set<TouchPoint> = []
  
  public var currentPressure: CGFloat?
  
  /// Active strokes being drawn, keyed by touch ID
  /// As I understand it, the item count for this is always
  /// going to match the number of `touches`.
  ///
  /// Once a stroke is complete (finger is lifted off the trackpad),
  /// it becomes
  public var activeStrokes: [Int: TouchStroke] = [:]

  /// Minimum number of points required to create a smooth curve
  let minPointsForCurve = 3

  /// Clear all strokes
  public mutating func clearStrokes() {
    activeStrokes.removeAll()
    artwork.completedStrokes.removeAll()
  }

  public mutating func updatecanvasSize(_ size: CGSize) {
    artwork.canvasSize = size
  }

  public init(canvasSize: CGSize) {
    print("`StrokeHandler` created at \(Date.now.format(.timeDetailed))")
    artwork.canvasSize = canvasSize
  }
}

extension StrokeHandler {
  
//  public var currentPressure: CGFloat? {
//    guard let firstTouch = touches.first else { return nil }
//    return firstTouch.pressure
//  }

  /// This property allows the Canvas view to draw not only completed/captured
  /// strokes, but those being *actively drawn* in real time as well.
  public var allStrokes: [TouchStroke] {
    return Array(activeStrokes.values) + artwork.completedStrokes
  }
  
  /// Process touch updates and update strokes
  public mutating func processTouchesIntoStrokes(
    pointConfig: PointConfig
  ) {

    guard artwork.canvasSize != .zero else {
      print("Canvas size cannot be zero, skipping touch processing.")
      return
    }

    for touch in touches {
      handleTouch(touch, pointConfig: pointConfig)
    }

    /// Finalize ended strokes
    /// Get the ID's for every `TrackpadTouch` in `touches`
    let currentIds = Set(touches.map { $0.id })

    /// Active `TouchStroke`s are keyed by their ID (`Int`)
    let activeIds = Set(activeStrokes.keys)

    let endedIds = activeIds.subtracting(currentIds)
    
    for touchId in endedIds {
      if let stroke = activeStrokes[touchId] {
        artwork.completedStrokes.append(stroke)
      }
      activeStrokes.removeValue(forKey: touchId)
    }
  }

  mutating func handleTouch(
    _ touch: TouchPoint,
    pointConfig: PointConfig
  ) {
    
    let touchId = touch.id
    let touchPosition = touch.position.convertNormalisedToConcrete(in: artwork.canvasSize)
    let timeStamp = touch.timestamp
    let strokePointPosition = TouchPoint(
      id: touchId,
      position: touchPosition,
      timestamp: timeStamp,
      velocity: touch.velocity,
      pressure: currentPressure
    )
    
    
    if activeStrokes[touchId] == nil {
      let newStroke = TouchStroke(id: UUID(), points: [strokePointPosition], colour: .asciiPurple)
      activeStrokes[touchId] = newStroke
    } else {
      activeStrokes[touchId]?.points.append(strokePointPosition)
    }
    
  }

}
