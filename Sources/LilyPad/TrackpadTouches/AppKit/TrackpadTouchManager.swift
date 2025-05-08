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

  var activeTouches: Set<NSTouch> = []

  /// Dictionary to store the last known touch for each touch ID
  private var lastTouches: [Int: TouchPoint] = [:]

  /// Maximum number of touch points to keep in history per stroke
  private let maxHistoryLength = 3
  
  /// Dictionary to store touch history for each touch ID
  private var touchHistories: [Int: [TouchPoint]] = [:]
  
  var currentPressure: CGFloat = .zero

  /// Process new touches and calculate velocity based on history
  public func processTouches(
    timestamp: TimeInterval,
    in view: NSView
  ) -> Set<TouchPoint> {

    var updatedTouches = Set<TouchPoint>()

    for touch in activeTouches {
      let touchId = touch.identity.hash
      let previousTouch = lastTouches[touchId]

      let newTouch = makeTouch(
        from: touch,
        timestamp: timestamp,
        previous: previousTouch,
        in: view
      )

      updatedTouches.insert(newTouch)

      /// Update last touch
      lastTouches[touchId] = newTouch
      
      /// Update touch history
      updateHistory(for: touchId, with: newTouch)
    }

    /// Handle ended touches (those in `lastTouches` but not in the current set)
    let currentIds = Set(activeTouches.map { $0.identity.hash })
    let lastIds = Set(lastTouches.keys)
    let endedIds = lastIds.subtracting(currentIds)

    for endedId in endedIds {
      /// Clean up ended touches
      lastTouches.removeValue(forKey: endedId)
            touchHistories.removeValue(forKey: endedId)
    }

    return updatedTouches
  }

  func makeTouch(
    from nsTouch: NSTouch,
    timestamp: TimeInterval,
    previous: TouchPoint?,
    in view: NSView,
  ) -> TouchPoint {
    
//    print("Made a touch")
    let now = timestamp
    let position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      /// Flip Y to match SwiftUI coordinate system
      y: 1.0 - nsTouch.normalizedPosition.y
    )

    let velocity: CGVector = {
      guard let prev = previous else { return .zero }
      return CGVector.between(prev.position, position, dt: now - prev.timestamp)
    }()

    return TouchPoint(
      id: nsTouch.identity.hash,
      position: position,
      timestamp: timestamp,
      velocity: velocity,
      pressure: currentPressure
    )
  }

  /// Updates the history for a specific touch ID
    private func updateHistory(for touchId: Int, with touch: TouchPoint) {
      var history = touchHistories[touchId] ?? []
      history.append(touch)
  
      /// Limit history length
      if history.count > maxHistoryLength {
        history.removeFirst()
      }
  
      touchHistories[touchId] = history
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
