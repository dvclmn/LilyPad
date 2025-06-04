//
//  Model+Gesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import AppKit

public enum GestureType: String, Sendable {
  case none
  case pan
  case zoom
  case rotate
}



public struct RawGesture: Identifiable, Hashable, Sendable {
  public let id: UUID
//  public let phase: TrackpadGesturePhase
  public let touches: [MappedTouchPoint]
}

public struct TrackpadGesture: Identifiable, Hashable, Sendable {
  public let id: UUID
  public let type: GestureType
//  public let phase: TrackpadGesturePhase
//  public let touches: [TouchPoint]
  
  public static let none = TrackpadGesture(
    id: UUID(),
    type: .none,
//    phase: .none
  )
}

