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

      switch phase {

          #warning("Consider here if stationery touches want special handling, to achieve some sort of palm rejection")
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

      let rawTouch = makeRawTouch(
        from: touch,
        touchId: touchId,
        phase: phase,
        timestamp: timestamp,
//        pressure: pressure
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


  private func makeRawTouch(
    from nsTouch: NSTouch,
    touchId: Int,
    phase: NSTouch.Phase,
    timestamp: TimeInterval,
//    pressure: CGFloat
  ) -> TouchPoint {
    let position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      y: 1.0 - nsTouch.normalizedPosition.y  // Flip Y
    )

    // You might need to adjust how you get pressure
    //    let currentPressure: CGFloat = nsTouch.pressure > 0 ? nsTouch.pressure : 1.0

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
