//
//  AppHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import BaseHelpers
import SwiftUI

@Observable
public final class AppHandler {

  var touches: Set<TrackpadTouch> = []

  var strokeHandler = StrokeHandler()

  var strokeEngine = StrokeEngine()

  let isDebugMode: Bool = false
  var windowSize: CGSize = .zero
  var isPointerLocked: Bool = false
  var isClicked: Bool = false

  //  let minDistanceThreshold: CGFloat = 10
  //  let minSpeedForSparseSampling: CGFloat = 0.1

  public init() {}

}

extension AppHandler {

  var trackPadSize: CGSize {
    let trackPadWidth: CGFloat = 700
    let trackPadAspectRatio: CGFloat = 10.0 / 16.0

    let trackPadHeight: CGFloat = trackPadWidth * trackPadAspectRatio

    return CGSize(
      width: trackPadWidth,
      height: trackPadHeight
    )
  }

  func touchPosition(_ touch: TrackpadTouch) -> CGPoint {

    let originX: CGFloat = 0
    let originY: CGFloat = 0

    let x = originX + (touch.position.x * trackPadSize.width)
    let y = originY + (touch.position.y * trackPadSize.height)

    return CGPoint(x: x, y: y)
  }

  var isInTouchMode: Bool {
    !isClicked && isPointerLocked
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
  //  public func processTouches() {
  //
  //    guard isInTouchMode else {
  //      print("No need to process touches, not in touch mode.")
  //      return
  //    }
  //
  //    if isDebugMode { print("Processing touches. Touch count: \(touches.count)") }
  //    /// Process each touch to update strokes
  //    for touch in touches {
  //      let touchId = touch.id
  //      let touchPosition = touchPosition(touch)
  //
  //      /// Calculate width based on velocity
  //      let width = strokeHandler.strokeWidth.calculateStrokeWidth(for: touch)
  //
  //      /// Update or create stroke for this touch
  //      if var stroke = strokeHandler.activeStrokes[touchId] {
  //        if isDebugMode {
  //          print("There are active strokes for touch \(touchId). Count: \(stroke.points.count)")
  //          print("Point count for stroke BEFORE: \(stroke.points.count)")
  //        }
  //
  //        if let last = stroke.points.last {
  //          let distance = hypot(touchPosition.x - last.x, touchPosition.y - last.y)
  //          let shouldAddPoint = distance > minDistanceThreshold || touch.speed < minSpeedForSparseSampling
  //          if shouldAddPoint {
  //            stroke.addPoint(touchPosition, width: width)
  //          }
  //        }
  //
  //
  ////        stroke.addPoint(touchPosition, width: width)
  //        strokeHandler.activeStrokes[touchId] = stroke
  //
  //      } else {
  //        /// New touch, create a new stroke
  //        if isDebugMode { print("Creating a new stroke for touch \(touchId)") }
  //
  //        let stroke = TouchStroke(
  //          points: [touchPosition],
  //          widths: [2],
  //          color: .purple
  //        )
  //        strokeHandler.activeStrokes[touchId] = stroke
  //      }
  //    }
  //
  //    /// Check for ended touches
  //    let currentIds = Set(touches.map { $0.id })
  //    let activeIds = Set(strokeHandler.activeStrokes.keys)
  //    let endedIds = activeIds.subtracting(currentIds)
  //
  //    /// Finalize ended strokes
  //    for touchId in endedIds {
  //      if let stroke = strokeHandler.activeStrokes[touchId], stroke.points.count >= strokeHandler.minPointsForCurve {
  //        strokeHandler.completedStrokes.append(stroke)
  //      }
  //      strokeHandler.activeStrokes.removeValue(forKey: touchId)
  //    }
  //  }

  // MARK: - Strokes

  public func clearStrokes() {
    strokeHandler.activeStrokes.removeAll()
    strokeHandler.completedStrokes.removeAll()
  }


}
