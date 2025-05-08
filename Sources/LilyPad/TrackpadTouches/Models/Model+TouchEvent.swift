//
//  Model+TouchEvent.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

public struct TouchEventData {
  let touches: Set<TouchPoint>
  let phase: TrackpadGesturePhase
  let pressure: CGFloat
  let timestamp: TimeInterval
}
