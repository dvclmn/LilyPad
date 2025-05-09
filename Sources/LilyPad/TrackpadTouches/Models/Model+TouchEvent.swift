//
//  Model+TouchEvent.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import AppKit

public struct TouchEventData: Sendable, Equatable {
  public let touches: Set<TouchPoint>
  public let phase: TrackpadGesturePhase
  public let pressure: CGFloat
  public let timestamp: TimeInterval
  
  public static let initial = TouchEventData(
    touches: [],
    phase: .none,
    pressure: .zero,
    timestamp: .zero
  )
}
extension TouchEventData: CustomStringConvertible {
  public var description: String {
    """
    TouchEventData
      - Touches: \(touches)
      - Phase: \(phase.rawValue)
      - Pressure: \(pressure.displayString)
      - Timestamp: \(timestamp.displayString)
    """
  }
}

