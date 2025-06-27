//
//  TouchesBuffer.swift
//  LilyPad
//
//  Created by Dave Coleman on 27/6/2025.
//

import AppKit

struct RawTouchData {
  let touches: Set<NSTouch>
  let pressure: CGFloat
}

final class TouchBuffer {
  private var latestTouches: Set<NSTouch> = []
  private var latestPressure: CGFloat?

  func update(with event: NSEvent) -> RawTouchData? {
    let eventTouches = event.allTouches()
    if !eventTouches.isEmpty {
      latestTouches = eventTouches
    }
    
    if event.type == .pressure {
      latestPressure = CGFloat(event.pressure)
      
      // Emit even if touches didn't update *just now*
      if !latestTouches.isEmpty {
        return RawTouchData(touches: latestTouches, pressure: latestPressure!)
      }
    }
    
    return nil
  }
  
//  func update(with event: NSEvent) -> RawTouchData? {
//    
//    
//    // Update only if this event contains touch info
//    let eventTouches = event.allTouches()
//    if !eventTouches.isEmpty {
//      latestTouches = eventTouches
//    }
//    
//    // Update pressure only if it's a pressure event
//    if event.type == .pressure {
//      latestPressure = CGFloat(event.pressure)
//    }
//    
//    // Bail if we don’t have both yet
//    guard !latestTouches.isEmpty, let pressure = latestPressure else {
//      return nil
//    }
//    
//    return RawTouchData(
//      touches: latestTouches,
//      pressure: pressure
//    )
//    
//    
//    
////    /// Pull out touches
////    latestTouches = event.allTouches()
////
////    /// Pull out pressure if present
////    if event.type == .pressure {
////      latestPressure = CGFloat(event.pressure)
////    }
////
////    /// Construct a TouchEventData only if we have both touches and pressure
////    guard let pressure = latestPressure else { return nil }
////
////    return RawTouchData(
////      touches: latestTouches,
////      pressure: pressure
////    )
//  }

  func reset() {
    latestTouches = []
    latestPressure = nil
  }
}
