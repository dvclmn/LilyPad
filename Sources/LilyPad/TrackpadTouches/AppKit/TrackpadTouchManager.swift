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

  /// Dictionary to store the last known touch for each touch ID
  private var lastTouches: [Int: TouchPoint] = [:]

  /// Maximum number of touch points to keep in history per stroke
  private let maxHistoryLength = 3

  /// Dictionary to store touch history for each touch ID
  private var touchHistories: [Int: [TouchPoint]] = [:]

  var currentPressure: CGFloat = .zero

  func processTouches(
    _ touches: Set<NSTouch>,
    phase: TrackpadGesturePhase,
    timestamp: TimeInterval
  ) -> TouchEventData {

    var updatedTouches = Set<TouchPoint>()

    for touch in touches {
      let touchId = touch.identity.hash
      let rawTouch = makeRawTouch(from: touch, touchId: touchId, timestamp: timestamp)

      /// Update history
      var history = touchHistories[touchId] ?? []
      history.append(rawTouch)
      if history.count > maxHistoryLength {
        history.removeFirst()
      }
      touchHistories[touchId] = history

      /// Compute velocity from updated history
      let velocity = computeVelocity(for: history)

      /// Finalize touch point with velocity
      let enrichedTouch = rawTouch.withVelocity(velocity)
      updatedTouches.insert(enrichedTouch)

      /// Store last touch for reference if needed
      lastTouches[touchId] = enrichedTouch
    }

    /// Cleanup ended touches
    let currentIDs = Set(touches.map { $0.identity.hash })
    let lastIDs = Set(lastTouches.keys)
    let endedIDs = lastIDs.subtracting(currentIDs)

    for endedId in endedIDs {
      lastTouches.removeValue(forKey: endedId)
      touchHistories.removeValue(forKey: endedId)
    }


    print(
      """

        processTouches():

        updatedTouches: \(updatedTouches)
        currentIDs: \(currentIDs)
        lastIDs: \(lastIDs)
        endedIDs: \(endedIDs)
      """)

    return TouchEventData(touches: updatedTouches, phase: phase)
  }

  /// Process new touches and calculate velocity based on history
  //  func processTouches(
  //    _ touches: Set<NSTouch>,
  //    phase: TrackpadGesturePhase,
  //    timestamp: TimeInterval
  //  ) -> TouchEventData {
  //
  //    var updatedTouches = Set<TouchPoint>()
  //
  //    for touch in touches {
  //      let touchId = ObjectIdentifier(touch.identity).hashValue
  ////      let touchId = touch.identity.hash
  //      let previousTouch = lastTouches[touchId]
  //
  //      let newTouch = makeTouch(
  //        from: touch,
  //        timestamp: timestamp,
  //        previous: previousTouch,
  //      )
  //
  //      updatedTouches.insert(newTouch)
  //
  //      /// Update last touch
  //      lastTouches[touchId] = newTouch
  //
  //      /// Update touch history
  //      updateHistory(for: touchId, with: newTouch)
  //    }
  //
  //    /// Handle ended touches (those in `lastTouches` but not in the current set)
  //    let currentIDs = Set(touches.map { $0.identity.hash })
  //    let lastIDs = Set(lastTouches.keys)
  //    let endedIDs = lastIDs.subtracting(currentIDs)
  //
  //    print("""
  //
  //      processTouches(_:phase:timstamp:)
  //
  //      updatedTouches: \(updatedTouches)
  //      currentIDs: \(currentIDs)
  //      lastIDs: \(lastIDs)
  //      endedIDs: \(endedIDs)
  //      """)
  //
  //    for endedId in endedIDs {
  //      /// Clean up ended touches
  //      lastTouches.removeValue(forKey: endedId)
  //      touchHistories.removeValue(forKey: endedId)
  //    }
  //
  //    let eventData = TouchEventData(touches: updatedTouches, phase: phase)
  //
  //    return eventData
  //  }


  private func makeRawTouch(from nsTouch: NSTouch, touchId: Int, timestamp: TimeInterval) -> TouchPoint {
    let position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      y: 1.0 - nsTouch.normalizedPosition.y  // Flip Y
    )

    return TouchPoint(
      id: touchId,
      position: position,
      timestamp: timestamp,
      pressure: currentPressure
    )
  }


  //  func makeTouch(
  //    from nsTouch: NSTouch,
  //    timestamp: TimeInterval,
  //    previous: TouchPoint?,
  //  ) -> TouchPoint {
  //
  //    let now = timestamp
  //    let position = CGPoint(
  //      x: nsTouch.normalizedPosition.x,
  //      /// Flip Y to match SwiftUI coordinate system
  //      y: 1.0 - nsTouch.normalizedPosition.y
  //    )
  //    let history = touchHistories[touchId] ?? []
  //    let velocity: CGVector = computeVelocity(for: history, current: <#T##TouchPoint#>)
  ////    {
  ////      guard let prev = previous else { return .zero }
  ////      return CGVector.between(prev.position, position, dt: now - prev.timestamp)
  ////    }()
  //
  //    return TouchPoint(
  //      id: nsTouch.identity.hash,
  //      position: position,
  //      timestamp: timestamp,
  //      velocity: velocity,
  //      pressure: currentPressure
  //    )
  //  }

  func id(for touch: NSTouch) -> Int {
    ObjectIdentifier(touch.identity).hashValue
  }

  private func computeVelocity(for history: [TouchPoint]) -> CGVector {
    guard history.count >= 2 else { return .zero }

    let a = history[history.count - 2]
    let b = history[history.count - 1]
    let dt = b.timestamp - a.timestamp

    guard dt > 0 else { return .zero }

    /// Replace with BaseHelpers `CGVector.between()`
    /// at some point
    return CGVector(
      dx: (b.position.x - a.position.x) / dt,
      dy: (b.position.y - a.position.y) / dt
    )
  }

  //  func computeVelocity(
  //    for history: [TouchPoint],
  //    current: TouchPoint
  //  ) -> CGVector {
  //    guard history.count >= 2, let first = history.first else { return .zero }
  //
  //    let dx = current.position.x - first.position.x
  //    let dy = current.position.y - first.position.y
  //    let dt = current.timestamp - first.timestamp
  //
  //    guard dt != 0 else { return .zero }
  //    return CGVector(dx: dx / dt, dy: dy / dt)
  //  }
  //
  //  /// Updates the history for a specific touch ID
  //  private func updateHistory(for touchId: Int, with touch: TouchPoint) {
  //    var history = touchHistories[touchId] ?? []
  //    history.append(touch)
  //
  //    /// Limit history length
  //    if history.count > maxHistoryLength {
  //      history.removeFirst()
  //    }
  //
  //    touchHistories[touchId] = history
  //  }

  /// Get the touch history for a specific ID
  public func history(for touchId: Int) -> [TouchPoint]? {
    return touchHistories[touchId]
  }

  /// Clear all touch history
  public func clearHistory() {
    lastTouches.removeAll()
    touchHistories.removeAll()
  }
}
