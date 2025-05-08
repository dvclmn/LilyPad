//
//  Model+TouchEvent.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import AppKit

public struct TouchEventData {
  let touches: Set<NSTouch>
  let phase: TrackpadGesturePhase
  let pressure: CGFloat
  let timestamp: TimeInterval
}
