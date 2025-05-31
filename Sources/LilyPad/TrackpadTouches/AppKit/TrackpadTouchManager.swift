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
  ///
  /// Note from Claude:
  /// For trackpad velocity calculations, I'd recommend 5-7 points in your
  /// rolling window, rather than your current 3. Here's why:
  /// Apple's Trackpad Frequency: Modern MacBook trackpads report at ~120Hz (about every 8ms),
  /// which is quite high-frequency. With only 3 points, you're looking at roughly 16ms of history,
  /// which might be too brief to smooth out jitter while still being responsive.
  /// You might even make it adaptive:
  /// ```
  /// private func historyLengthFor(phase: TrackpadTouchPhase) -> Int {
  ///   switch phase {
  ///     case .began: return 3      // Less history needed at start
  ///     case .moved: return 6      // Full smoothing during movement
  ///     case .ended: return 4      // Slightly less as touch ends
  ///   }
  /// }
  /// ```
  private let maxHistoryLength = 7
  
  /// Weight recent points more heavily
  let weights = [0.1, 0.15, 0.2, 0.25, 0.3] // Most recent gets 0.3

  /// Dictionary to store touch history for each touch ID
  private var touchHistories: [Int: [TouchPoint]] = [:]

  func processCapturedTouches(
    _ touches: Set<NSTouch>,
    //    phase: NSTouch.Phase,
    timestamp: TimeInterval,
    //    pressure: CGFloat
  ) -> TouchEventData? {

    var updatedTouches = Set<TouchPoint>()

    for touch in touches {

      let touchId = touch.identity.hash
      let phase = touch.phase

//      #warning("Consider here if stationery touches want special handling, to achieve some sort of palm rejection")

      switch phase {

        case .began, .moved:
          activeTouches.insert(touchId)

        case .ended, .cancelled:
          /// Remove just this touch
          activeTouches.remove(touchId)
          touchHistories.removeValue(forKey: touchId)
          lastTouches.removeValue(forKey: touchId)

        default:
          break
      }

      let rawTouch = makeTouchPoint(
        from: touch,
        touchId: touchId,
        phase: phase,
        timestamp: timestamp,
      )

      var history = touchHistories[touchId] ?? []
      history.append(rawTouch)
      if history.count > maxHistoryLength {
        history.removeFirst()
      }
      touchHistories[touchId] = history

      let velocity = computeVelocity(for: history)
      let enrichedTouch = rawTouch.withVelocity(velocity)
      updatedTouches.insert(enrichedTouch)

      lastTouches[touchId] = enrichedTouch

    }

    /// Return the updated data for this event
    return TouchEventData(
      touches: updatedTouches
    )
  }


  private func makeTouchPoint(
    from nsTouch: NSTouch,
    touchId: Int,
    phase: NSTouch.Phase,
    timestamp: TimeInterval,
  ) -> TouchPoint {
    
    let position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      y: 1.0 - nsTouch.normalizedPosition.y  // Flip Y
    )

    let result = TouchPoint(
      id: touchId,
      phase: phase.toDomainPhase,
      position: position,
      timestamp: timestamp,
      velocity: CGVector.zero,  // Will be populated by withVelocity()
      pressure: .zero
    )

    return result
  }

//  func id(for touch: NSTouch) -> Int {
//    ObjectIdentifier(touch.identity).hashValue
//  }

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

}


extension NSTouch.Phase {
  var toDomainPhase: TrackpadTouchPhase {
    switch self {
      case .began: .began
      case .cancelled: .cancelled
      case .ended: .ended
      case .moved: .moved
      case .stationary: .stationary
      default: .none
    }
  }
}
