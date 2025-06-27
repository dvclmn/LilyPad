//
//  TrackpadTouchManager.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import AppKit
import Foundation

/// Manages trackpad touches and maintains their history for velocity calculations
public class TrackpadTouchManager {

  public var activeTouches: Set<Int> = []

  /// Dictionary to store the last known touch for each touch ID
  private var lastTouches: [Int: TouchPoint] = [:]

  /// Maximum number of touch points to keep in history per stroke
//  private let maxHistoryLength = 7

  /// Dictionary to store touch history for each touch ID
  private var touchHistories: [Int: [TouchPoint]] = [:]

  /// Weights for velocity calculation (most recent points weighted more heavily)
  /// Should have maxHistoryLength - 1 elements for velocity pairs
  private let velocityWeights: [Double] = [0.05, 0.1, 0.15, 0.25, 0.35, 0.1]

  /// Minimum time delta to consider for velocity calculation (avoid division by tiny numbers)
//  private let minTimeDelta: TimeInterval = 0.001

  /// Maximum reasonable velocity to prevent outliers (points per second)
//  private let

  func processCapturedTouches(
    //    _ touches: [NSTouch: CGFloat],
    _ nsTouches: Set<NSTouch>,
    timestamp: TimeInterval,

  ) -> Set<TouchPoint> {
    //  ) -> TouchEventData? {

    var updatedTouches = Set<TouchPoint>()

    for nsTouch in nsTouches {
      let touchId = nsTouch.identity.hash
      let phase = nsTouch.phase

      /// Handle touch lifecycle
      switch phase {
        case .began, .moved:
          activeTouches.insert(touchId)

        case .ended, .cancelled:
          activeTouches.remove(touchId)

          /// Clean up after processing this touch, now that it is finished
          touchHistories.removeValue(forKey: touchId)
          lastTouches.removeValue(forKey: touchId)

        default:
          break
      }

      /// Create raw touch point
      let rawTouch = TouchPoint(
        from: nsTouch,
        touchID: touchId,
        phase: phase,
        timestamp: timestamp,
        deviceSize: nsTouch.deviceSize,
        isResting: nsTouch.isResting
      )

      /// Update history
      updateTouchHistory(touchId: touchId, touchPoint: rawTouch)

      /// Compute velocity based on history
      let velocity = computeWeightedVelocity(for: touchId)

      /// Create final touch with computed velocity
      let enrichedTouch = rawTouch.withVelocity(velocity)
      updatedTouches.insert(enrichedTouch)
      lastTouches[touchId] = enrichedTouch

    }

    guard !updatedTouches.isEmpty else { return nil }

    return TouchEventData(touches: updatedTouches)
  }


  private func updateTouchHistory(
    touchId: Int,
    touchPoint: TouchPoint
  ) {
    var history = touchHistories[touchId] ?? []

    /// Add the newest point to this touch's history
    history.append(touchPoint)

    /// Maintain rolling window
    if history.count > maxHistoryLength {
      history.removeFirst()
    }

    /// Update the history entry itself
    touchHistories[touchId] = history
  }

  
//  private func computeSimpleVelocity(from pointA: TouchPoint, to pointB: TouchPoint) -> CGVector {
//    let dt = pointB.timestamp - pointA.timestamp
//    guard dt >= minTimeDelta else { return .zero }
//
//    return CGVector(
//      dx: (pointB.position.x - pointA.position.x) / dt,
//      dy: (pointB.position.y - pointA.position.y) / dt
//    )
//  }
//
//  private func clampVelocity(_ velocity: CGVector) -> CGVector {
//    let magnitude = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
//
//    guard magnitude > maxVelocity else { return velocity }
//
//    /// Scale down to max velocity while preserving direction
//    let scale = maxVelocity / magnitude
//    return CGVector(
//      dx: velocity.dx * scale,
//      dy: velocity.dy * scale
//    )
//  }
}
