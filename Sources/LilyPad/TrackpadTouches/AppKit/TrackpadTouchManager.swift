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
  private let maxHistoryLength = 3

  /// Dictionary to store touch history for each touch ID
  private var touchHistories: [Int: [TouchPoint]] = [:]

  var currentPressure: CGFloat = .zero

  func processTouches(
    _ touches: Set<NSTouch>,
    phase: TrackpadGesturePhase,
    timestamp: TimeInterval
  ) -> TouchEventData? {
    
    print("How many touches right now? \(touches.count). And the phase is: \(phase)")
    
    let currentIDs = Set(touches.map { id(for: $0) })
    
    // If all fingers lifted, but the event doesn't give us any touches:
//    if touches.isEmpty && (phase == .ended || phase == .cancelled) {
//      // Copy any remaining touches to return in this final event
//      let remainingTouches = Set(lastTouches.values)
//      
//      // Clear all stored state
//      lastTouches.removeAll()
//      touchHistories.removeAll()
//      activeTouches.removeAll()
//      
//      return TouchEventData(touches: remainingTouches, phase: phase)
//    }
    
    var updatedTouches = Set<TouchPoint>()
    
    /// Really hoping this line right here, helps to properly 'remove'
    /// touches, when the last finger is lifted off.
//    guard !touches.isEmpty else { return nil }
//    guard !touches.isEmpty else {
//      activeTouches = []
//      return nil
//    }
//    
//    var updatedTouches = Set<TouchPoint>()

    for touch in touches {
      let touchId = id(for: touch)
      let rawTouch = makeRawTouch(
        from: touch,
        touchId: touchId,
        phase: phase,
        timestamp: timestamp
      )

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

    /// Updates the internal touch state by removing ended touches and maintaining active ones.
    ///
    /// This section is responsible for tracking which touches are still active on the trackpad,
    /// and cleaning up any touch state associated with fingers that have been lifted.
    ///
    /// - Note: `NSTouch` instances are not retained across events, so we identify them
    ///   by hashing their `identity` property. Each touch has a unique identity for its
    ///   lifecycle on the trackpad.
    ///
    /// The logic works as follows:
    /// 1. Create a set of currently present touch IDs (`currentIDs`) from the incoming touch set.
    /// 2. Look at the previously known touch IDs (`lastIDs`), from the `lastTouches` dictionary.
    /// 3. Calculate the difference (`endedIDs`), which tells us which touches have ended.
    /// 4. Clean up the state associated with ended touches by removing their entries from:
    ///     - `lastTouches` (the last known position and velocity)
    ///     - `touchHistories` (historical touch points used for velocity computation)
    ///     - `activeTouches` (a public-facing set of current touch IDs)
    ///
    /// This cleanup ensures that stale data does not linger between gesture events, and
    /// helps external consumers (such as a SwiftUI view) reliably track when touches end.
    
    
    // Update active touch IDs
    let lastIDs = Set(lastTouches.keys)
    let endedIDs = lastIDs.subtracting(currentIDs)
    activeTouches = currentIDs
    
    for endedId in endedIDs {
      lastTouches.removeValue(forKey: endedId)
      touchHistories.removeValue(forKey: endedId)
      activeTouches.remove(endedId)
    }
    
//    let currentIDs = Set(touches.map { $0.identity.hash })
//    let lastIDs = Set(lastTouches.keys)
//    let endedIDs = lastIDs.subtracting(currentIDs)
//    activeTouches = currentIDs
//
//    for endedId in endedIDs {
//      lastTouches.removeValue(forKey: endedId)
//      touchHistories.removeValue(forKey: endedId)
//      activeTouches.remove(endedId)
//    }

    return TouchEventData(touches: updatedTouches, phase: phase)
  }

  private func makeRawTouch(
    from nsTouch: NSTouch,
    touchId: Int,
    phase: TrackpadGesturePhase,
    timestamp: TimeInterval
  ) -> TouchPoint {
    let position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      y: 1.0 - nsTouch.normalizedPosition.y  // Flip Y
    )

    return TouchPoint(
      id: touchId,
      phase: phase,
      position: position,
      timestamp: timestamp,
      pressure: currentPressure
    )
  }

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
