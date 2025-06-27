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
    /// Pull out touches
    latestTouches = event.allTouches()

    /// Pull out pressure if present
    if event.type == .pressure {
      latestPressure = CGFloat(event.pressure)
    }

    /// Construct a TouchEventData only if we have both touches and pressure
    guard let pressure = latestPressure else { return nil }

    return RawTouchData(
      touches: latestTouches,
      pressure: pressure
    )
  }

  func reset() {
    latestTouches = []
    latestPressure = nil
  }
}
