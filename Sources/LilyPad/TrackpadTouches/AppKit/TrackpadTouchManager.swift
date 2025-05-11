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

  func processCapturedTouches(
    _ touches: Set<NSTouch>,
    phase: TrackpadGesturePhase,
    timestamp: TimeInterval
  ) -> TouchEventData? {
    
    print("`TrackpadTouchManager`: Number of touches: \(touches.count). Phase: \(phase)")
    
    var updatedTouches = Set<TouchPoint>()
    
    for touch in touches {
      let touchId = touch.identity.hash
      let rawTouch = makeRawTouch(
        from: touch,
        touchId: touchId,
        phase: phase,
        timestamp: timestamp
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
      
      // Update touch state based on phase
      switch touch.phase {
        case .began, .moved, .stationary:
          activeTouches.insert(touchId)
          lastTouches[touchId] = enrichedTouch
          
        case .ended, .cancelled:
          activeTouches.remove(touchId)
          lastTouches.removeValue(forKey: touchId)
          touchHistories.removeValue(forKey: touchId)
        default:
          break
      }
    }
    
    return TouchEventData(touches: updatedTouches, phase: phase)
    
//    guard !touches.isEmpty else {
//      activeTouches.removeAll()
//      
//      return nil
//    }
//    
//    var updatedTouches = Set<TouchPoint>()
//    var endedIDs = Set<Int>()
//    var currentIDs = Set<Int>()
//    
//    for touch in touches {
//      let touchId = touch.identity.hash
//      let rawTouch = makeRawTouch(
//        from: touch,
//        touchId: touchId,
//        phase: phase,
//        timestamp: timestamp
//      )
//      
//      // Update history
//      var history = touchHistories[touchId] ?? []
//      history.append(rawTouch)
//      if history.count > maxHistoryLength {
//        history.removeFirst()
//      }
//      touchHistories[touchId] = history
//      
//      // Compute velocity
//      let velocity = computeVelocity(for: history)
//      let enrichedTouch = rawTouch.withVelocity(velocity)
//      
//      updatedTouches.insert(enrichedTouch)
//      lastTouches[touchId] = enrichedTouch
//      currentIDs.insert(touchId)
//      
//      // Mark ended touches for cleanup
//      if touch.phase == .ended || touch.phase == .cancelled {
//        endedIDs.insert(touchId)
//      }
//    }
//    
//    // Cleanup ended touches
//    for endedId in endedIDs {
//      lastTouches.removeValue(forKey: endedId)
//      touchHistories.removeValue(forKey: endedId)
//      activeTouches.remove(endedId)
//    }
//    
//    // Update active touch list
//    activeTouches = currentIDs.subtracting(endedIDs)
//    
//    return TouchEventData(touches: updatedTouches, phase: phase)
    
    
   
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
