//
//  StrokeHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import BaseHelpers
import SwiftUI



public struct StrokeHandler {

  public var engine = StrokeEngine()

  /// The number of fingers touching the trackpad
  /// Inadvertant touches may be made by a palm etc as well.
  public var touches: Set<TrackpadTouch> = []
  
  public var currentPressure: CGFloat?
  
  private var canvasSize: CGSize

  /// Active strokes being drawn, keyed by touch ID
  /// As I understand it, the item count for this is always
  /// going to match the number of `touches`.
  ///
  /// Once a stroke is complete (finger is lifted off the trackpad),
  /// it becomes
  public var activeStrokes: [Int: TouchStroke] = [:]

  /// Completed strokes
  public var completedStrokes: [TouchStroke] = []
  
//  public var completedRawTouches: [TouchStroke.ID: [TrackpadTouch]] = [:]
//  public var completedRawTouches: [RawTouches] = []
  
  

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
  
//  public var currentPressure: CGFloat? {
//    guard let firstTouch = touches.first else { return nil }
//    return firstTouch.pressure
//  }

  /// This property allows the Canvas view to draw not only completed/captured
  /// strokes, but those being *actively drawn* in real time as well.
  public var allStrokes: [TouchStroke] {
    return Array(activeStrokes.values) + completedStrokes
  }
  
//  public mutating func processTouchesIntoStrokesDebugVersion() {
//    
//    guard canvasSize != .zero else {
//      print("Canvas size cannot be zero, skipping touch processing.")
//      return
//    }
//    
//    /// I don't need touches, only need the saved stuff, right?
//    
//    
////    guard !touches.isEmpty else {
////      print("No touches to process.")
////      return
////    }
////    
////    for touch in touches {
////      handleTouch(touch, isDebugMode: isDebugMode)
////    }
////    
////    /// Finalize ended strokes
////    /// Get the ID's for every `TrackpadTouch` in `touches`
////    let currentIds = Set(touches.map { $0.id })
////    
////    /// Active `TouchStroke`s are keyed by their ID (`Int`)
////    let activeIds = Set(activeStrokes.keys)
////    
////    let endedIds = activeIds.subtracting(currentIds)
////    
////    for touchId in endedIds {
////      if let stroke = activeStrokes[touchId], stroke.points.count >= minPointsForCurve {
////        completedStrokes.append(stroke)
////      }
////      activeStrokes.removeValue(forKey: touchId)
////    }
//  }

  /// Process touch updates and update strokes
  public mutating func processTouchesIntoStrokes(isDebugMode: Bool = false) {

    guard canvasSize != .zero else {
      print("Canvas size cannot be zero, skipping touch processing.")
      return
    }
    
    if isDebugMode {
      let savedTouches = completedStrokes.flatMap { stroke in
        stroke.rawTouchPoints
      }
      let touchesSet: Set<TrackpadTouch> = Set(savedTouches)
      touches = touchesSet
      
      for touch in touches {
        handleTouch(touch, isDebugMode: isDebugMode)
      }
      
      return
    }
//
//    guard !touches.isEmpty else {
//      print("No touches to process.")
//      return
//    }

    for touch in touches {
      handleTouch(touch, isDebugMode: isDebugMode)
    }

    /// Finalize ended strokes
    /// Get the ID's for every `TrackpadTouch` in `touches`
    let currentIds = Set(touches.map { $0.id })

    /// Active `TouchStroke`s are keyed by their ID (`Int`)
    let activeIds = Set(activeStrokes.keys)

    let endedIds = activeIds.subtracting(currentIds)
    
    for touchId in endedIds {
      if let stroke = activeStrokes[touchId], stroke.points.count >= minPointsForCurve {
        completedStrokes.append(stroke)
      }
      activeStrokes.removeValue(forKey: touchId)
    }
  }

  mutating func handleTouch(_ touch: TrackpadTouch, isDebugMode: Bool) {

    /// Set up some convenient constants
    let touchId = touch.id
    let touchPosition = touch.position.convertNormalisedToConcrete(in: canvasSize)
    let timeStamp = touch.timestamp
    let touchSpeed = touch.velocity.speed

    /// Width is not yet considered at this stage.
    /// It is later calculated based on velocity etc.
    let strokePointPosition = StrokePoint(
      position: touchPosition,
      timestamp: timeStamp,
      velocity: touch.velocity,
      pressure: currentPressure
    )

    /// When first running the app, or after clearing `activeStrokes` will be empty
    guard var stroke = activeStrokes[touchId] else {
      /// First point for new stroke
      let newStroke = TouchStroke(points: [strokePointPosition], colour: .purple)
      activeStrokes[touchId] = newStroke
      return  // Move to next touch in the loop
    }

    /// Handle existing stroke
    ///
    /// We get the *last* stroke point, so we can compare it against
    /// `touchPosition`.
    if let last = stroke.points.last {

      /// Set up the boolean, to determine if we add this point or not
      let shouldAdd = engine.shouldAddPoint(
        from: last.position,
        to: touchPosition,
        speed: touchSpeed
      )

      if shouldAdd {
        stroke.addPoint(kind: .strokePoint(strokePointPosition))
      }
    }
    /// Let's also add to our backup of raw touches
    if !isDebugMode {
      
      stroke.addPoint(kind: .rawTouchPoint(touch))
      
//      completedRawTouches[stroke.id]?.append(touch)
    }
    activeStrokes[touchId] = stroke
  }

}
