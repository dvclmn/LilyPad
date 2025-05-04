//
//  TrackpadTouchManager.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import Foundation
import AppKit

/// Manages trackpad touches and maintains their history for velocity calculations
public class TrackpadTouchManager {
  
  /// Dictionary to store the last known touch for each touch ID
  private var lastTouches: [Int: TrackpadTouch] = [:]
  
  /// Maximum number of touch points to keep in history per stroke
  private let maxHistoryLength = 10
  
  /// Dictionary to store touch history for each touch ID
  private var touchHistories: [Int: [TrackpadTouch]] = [:]
  
  /// Process new touches and calculate velocity based on history
  public func processTouches(_ touches: Set<NSTouch>, in view: NSView) -> Set<TrackpadTouch> {
    
    var updatedTouches = Set<TrackpadTouch>()
    
    for touch in touches {
      let touchId = touch.identity.hash
      let previousTouch = lastTouches[touchId]
      
      /// Create a new touch with velocity information based on the previous touch
      let newTouch = TrackpadTouch(touch, previousTouch: previousTouch)
      
      updatedTouches.insert(newTouch)
      
      /// Update last touch
      lastTouches[touchId] = newTouch
      
      /// Update touch history
      updateHistory(for: touchId, with: newTouch)
    }
    
    /// Handle ended touches (those in `lastTouches` but not in the current set)
    let currentIds = Set(touches.map { $0.identity.hash })
    let lastIds = Set(lastTouches.keys)
    let endedIds = lastIds.subtracting(currentIds)
    
    for endedId in endedIds {
      /// Clean up ended touches
      lastTouches.removeValue(forKey: endedId)
      touchHistories.removeValue(forKey: endedId)
    }
    
    return updatedTouches
  }
  
  /// Updates the history for a specific touch ID
  private func updateHistory(for touchId: Int, with touch: TrackpadTouch) {
    var history = touchHistories[touchId] ?? []
    history.append(touch)
    
    /// Limit history length
    if history.count > maxHistoryLength {
      history.removeFirst()
    }
    
    touchHistories[touchId] = history
  }
  
  /// Get the touch history for a specific ID
  public func history(for touchId: Int) -> [TrackpadTouch]? {
    return touchHistories[touchId]
  }
  
  /// Clear all touch history
  public func clearHistory() {
    lastTouches.removeAll()
    touchHistories.removeAll()
  }
}
