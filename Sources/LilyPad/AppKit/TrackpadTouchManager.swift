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
  private let maxHistoryLength = 7

  /// Dictionary to store touch history for each touch ID
  private var touchHistories: [Int: [TouchPoint]] = [:]

  /// Weights for velocity calculation (most recent points weighted more heavily)
  /// Should have maxHistoryLength - 1 elements for velocity pairs
  private let velocityWeights: [Double] = [0.05, 0.1, 0.15, 0.25, 0.35, 0.1]

  /// Minimum time delta to consider for velocity calculation (avoid division by tiny numbers)
  private let minTimeDelta: TimeInterval = 0.001

  /// Maximum reasonable velocity to prevent outliers (points per second)
  private let maxVelocity: Double = 10.0

  func processCapturedTouches(
    _ touches: [NSTouch: CGFloat],
//    _ touches: Set<NSTouch>,
    timestamp: TimeInterval,
    
  ) -> TouchEventData? {

    var updatedTouches = Set<TouchPoint>()

    for (touch, pressure) in touches {
      let touchId = touch.identity.hash
      let phase = touch.phase

      /// Handle touch lifecycle
      switch phase {
        case .began, .moved:
          activeTouches.insert(touchId)
        case .ended, .cancelled:
          activeTouches.remove(touchId)
          /// Clean up after processing this final touch
          do {
            touchHistories.removeValue(forKey: touchId)
            lastTouches.removeValue(forKey: touchId)
          }
        default:
          break
      }

      /// Create raw touch point
      let rawTouch = makeTouchPoint(
        from: touch,
        touchId: touchId,
        phase: phase,
        timestamp: timestamp
      )

      /// Update history
      updateTouchHistory(touchId: touchId, touchPoint: rawTouch)
      
      if includeVelocity {
        /// Compute velocity based on history
        let velocity = computeWeightedVelocity(for: touchId)
        
        /// Create final touch with computed velocity
        let enrichedTouch = rawTouch.withVelocity(velocity)
        updatedTouches.insert(enrichedTouch)
        lastTouches[touchId] = enrichedTouch
        
      } else {
        updatedTouches.insert(rawTouch)
        lastTouches[touchId] = rawTouch
      }

    }

    guard !updatedTouches.isEmpty else { return nil }

    return TouchEventData(touches: updatedTouches)
  }


  private func updateTouchHistory(touchId: Int, touchPoint: TouchPoint) {
    var history = touchHistories[touchId] ?? []
    history.append(touchPoint)

    /// Maintain rolling window
    if history.count > maxHistoryLength {
      history.removeFirst()
    }

    touchHistories[touchId] = history
  }

  private func computeWeightedVelocity(for touchId: Int) -> CGVector {
    guard let history = touchHistories[touchId],
      history.count >= 2
    else {
      return .zero
    }

    /// For very short history, use simple calculation
    if history.count == 2 {
      return computeSimpleVelocity(from: history[0], to: history[1])
    }

    /// Weighted average of velocities between consecutive points
    var weightedDx: Double = 0
    var weightedDy: Double = 0
    var totalWeight: Double = 0

    /// Calculate velocity between each consecutive pair
    for i in 1..<history.count {
      let velocity = computeSimpleVelocity(from: history[i - 1], to: history[i])

      /// Use weight based on how recent this velocity sample is
      /// More recent samples (higher index) get higher weight
      let weightIndex = min(i - 1, velocityWeights.count - 1)
      let weight = velocityWeights[weightIndex]

      weightedDx += velocity.dx * weight
      weightedDy += velocity.dy * weight
      totalWeight += weight
    }

    guard totalWeight > 0 else { return .zero }

    let finalVelocity = CGVector(
      dx: weightedDx / totalWeight,
      dy: weightedDy / totalWeight
    )

    /// Clamp to reasonable bounds to prevent outliers
    return clampVelocity(finalVelocity)
  }

  private func computeSimpleVelocity(from pointA: TouchPoint, to pointB: TouchPoint) -> CGVector {
    let dt = pointB.timestamp - pointA.timestamp
    guard dt >= minTimeDelta else { return .zero }

    return CGVector(
      dx: (pointB.position.x - pointA.position.x) / dt,
      dy: (pointB.position.y - pointA.position.y) / dt
    )
  }

  private func clampVelocity(_ velocity: CGVector) -> CGVector {
    let magnitude = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)

    guard magnitude > maxVelocity else { return velocity }

    /// Scale down to max velocity while preserving direction
    let scale = maxVelocity / magnitude
    return CGVector(
      dx: velocity.dx * scale,
      dy: velocity.dy * scale
    )
  }

  private func makeTouchPoint(
    from nsTouch: NSTouch,
    touchId: Int,
    phase: NSTouch.Phase,
    timestamp: TimeInterval
  ) -> TouchPoint {
    let position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      y: 1.0 - nsTouch.normalizedPosition.y/// Flip Y
    )

    /// Extract pressure if available (some trackpads support this)
    ///    let pressure = CGFloat(nsTouch.force)

    return TouchPoint(
      id: touchId,
      phase: phase.toDomainPhase,
      position: position,
      timestamp: timestamp,
      velocity: CGVector.zero,  // Will be populated by withVelocity()
      pressure: .zero
    )
  }

  // MARK: - Public Utilities

  /// Get current velocity for a specific touch (useful for debugging/visualization)
  public func getCurrentVelocity(for touchId: Int) -> CGVector? {
    return lastTouches[touchId]?.velocity
  }

  /// Get touch history count for a specific touch (useful for debugging)
  public func getHistoryCount(for touchId: Int) -> Int {
    return touchHistories[touchId]?.count ?? 0
  }

  /// Clear all touch data (useful for app state changes)
  public func clearAllTouches() {
    activeTouches.removeAll()
    lastTouches.removeAll()
    touchHistories.removeAll()
  }
  //  private func makeTouchPoint(
  //    from nsTouch: NSTouch,
  //    touchId: Int,
  //    phase: NSTouch.Phase,
  //    timestamp: TimeInterval,
  //  ) -> TouchPoint {
  //
  //    let position = CGPoint(
  //      x: nsTouch.normalizedPosition.x,
  //      y: 1.0 - nsTouch.normalizedPosition.y  // Flip Y
  //    )
  //
  //    let result = TouchPoint(
  //      id: touchId,
  //      phase: phase.toDomainPhase,
  //      position: position,
  //      timestamp: timestamp,
  //      velocity: CGVector.zero,  // Will be populated by withVelocity()
  //      pressure: .zero
  //    )
  //
  //    return result
  //  }
  //
  ////  func id(for touch: NSTouch) -> Int {
  ////    ObjectIdentifier(touch.identity).hashValue
  ////  }
  //
  //  private func computeVelocity(for history: [TouchPoint]) -> CGVector {
  //    guard history.count >= 2 else { return .zero }
  //
  //    let a = history[history.count - 2]
  //    let b = history[history.count - 1]
  //    let dt = b.timestamp - a.timestamp
  //
  //    guard dt > 0 else { return .zero }
  //
  //    /// Replace with BaseHelpers `CGVector.between()`
  //    /// at some point
  //    return CGVector(
  //      dx: (b.position.x - a.position.x) / dt,
  //      dy: (b.position.y - a.position.y) / dt
  //    )
  //  }

}
