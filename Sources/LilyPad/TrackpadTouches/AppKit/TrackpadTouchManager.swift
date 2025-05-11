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
    var updatedTouches = Set<TouchPoint>()
    
    for touch in touches {
      let touchId = touch.identity.hash
      
      switch phase {
        case .began:
          activeTouches.insert(touchId)
          
        case .moved:
          // no insert needed, but you might want to check that it's already active
          print("Is this touch active? \(activeTouches.contains(touchId))")
          
        case .ended, .cancelled:
          activeTouches.remove(touchId)
          touchHistories.removeValue(forKey: touchId)
          lastTouches.removeValue(forKey: touchId)
          
        default:
          break
      }
      
      // Always construct and store updated TouchPoint for output
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
      
      print("Phase: \(phase), Touch ID: \(touchId)")
    }
    
    print("Active touches: \(activeTouches)")
//    // For ended/cancelled phases, we need to handle touch removal
//    if phase == .ended || phase == .cancelled {
//      for touch in touches {
//        let touchId = touch.identity.hash
//        
//        // Create a touch point with the end/cancel phase
//        let rawTouch = makeRawTouch(
//          from: touch,
//          touchId: touchId,
//          phase: phase,
//          timestamp: timestamp
//        )
//        
//        // Update history
//        var history = touchHistories[touchId] ?? []
//        history.append(rawTouch)
//        if history.count > maxHistoryLength {
//          history.removeFirst()
//        }
//        touchHistories[touchId] = history
//        
//        // Calculate velocity for the final touch
//        let velocity = computeVelocity(for: history)
//        let enrichedTouch = rawTouch.withVelocity(velocity)
//        updatedTouches.insert(enrichedTouch)
//        
//        // Remove from active touches as this touch has ended
//        activeTouches.remove(touchId)
//        
//        // If needed, also clean up history for ended touches to prevent memory leaks
//        if phase == .ended || phase == .cancelled {
//          touchHistories.removeValue(forKey: touchId)
//          lastTouches.removeValue(forKey: touchId)
//        }
//      }
//    } else {
//      // For began and moved phases
//      for touch in touches {
//        let touchId = touch.identity.hash
//        
//        // For began phase, add to active touches
//        if phase == .began {
//          activeTouches.insert(touchId)
//        }
//        
//        let rawTouch = makeRawTouch(
//          from: touch,
//          touchId: touchId,
//          phase: phase,
//          timestamp: timestamp
//        )
//        
//        // Update history
//        var history = touchHistories[touchId] ?? []
//        history.append(rawTouch)
//        if history.count > maxHistoryLength {
//          history.removeFirst()
//        }
//        touchHistories[touchId] = history
//        
//        // Calculate velocity and store enriched touch
//        let velocity = computeVelocity(for: history)
//        let enrichedTouch = rawTouch.withVelocity(velocity)
//        updatedTouches.insert(enrichedTouch)
//        
//        // Update last touch
//        lastTouches[touchId] = enrichedTouch
//      }
//    }
//
//    
//    // Only return event data if we have touches to report
//    if !updatedTouches.isEmpty {
//      return TouchEventData(touches: updatedTouches, phase: phase)
//    }
//    
//    return nil
    
    return nil
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
    
    // You might need to adjust how you get pressure
//    let currentPressure: CGFloat = nsTouch.pressure > 0 ? nsTouch.pressure : 1.0
    
    return TouchPoint(
      id: touchId,
      phase: phase,
      position: position,
      timestamp: timestamp,
      velocity: CGVector.zero, // Will be populated by withVelocity()
      pressure: currentPressure
    )
  }
//}

//  private func makeRawTouch(
//    from nsTouch: NSTouch,
//    touchId: Int,
//    phase: TrackpadGesturePhase,
//    timestamp: TimeInterval
//  ) -> TouchPoint {
//    let position = CGPoint(
//      x: nsTouch.normalizedPosition.x,
//      y: 1.0 - nsTouch.normalizedPosition.y  // Flip Y
//    )
//
//    return TouchPoint(
//      id: touchId,
//      phase: phase,
//      position: position,
//      timestamp: timestamp,
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
  
//  private func computeVelocity(for history: [TouchPoint]) -> CGVector {
//    // Implement velocity calculation from history
//    // This is just a placeholder - you'd implement actual velocity calculation
//    // based on position changes over time
//    if history.count < 2 {
//      return CGVector.zero
//    }
//    
//    let latest = history.last!
//    let previous = history[history.count - 2]
//    let dt = latest.timestamp - previous.timestamp
//    
//    if dt <= 0 {
//      return CGVector.zero
//    }
//    
//    let dx = latest.position.x - previous.position.x
//    let dy = latest.position.y - previous.position.y
//    
//    return CGVector(dx: dx / CGFloat(dt), dy: dy / CGFloat(dt))
//  }

  /// Get the touch history for a specific ID
//  public func history(for touchId: Int) -> [TouchPoint]? {
//    return touchHistories[touchId]
//  }
//
//  /// Clear all touch history
//  public func clearHistory() {
//    lastTouches.removeAll()
//    touchHistories.removeAll()
//  }
}
