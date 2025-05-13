//
//  Model+Gesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

public enum GestureType: Sendable {
  case none
  case draw
  case pan
  case zoom
  case rotate
}

struct MappingSpaces {
  var canvas: CGRect
  var viewport: CGRect
}


public enum TrackpadTouchPhase: String, Sendable, Equatable, Codable {
  case none
  case began
  case moved
  case stationary
  case ended
  case cancelled
}

public enum TrackpadGesturePhase: String, Sendable, Equatable, Codable {
  case none
  case began
  case changed
  case ended
  case cancelled
}

public struct TrackpadGesture: Identifiable, Hashable, Sendable {
  public let id: UUID
  public let phase: TrackpadGesturePhase
  public let touches: [TouchPoint]
}
