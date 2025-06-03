//
//  Model+Gesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import AppKit

public enum GestureType: String, Sendable {
  case unknown
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

extension NSTouch.Phase {
  var toDomainPhase: TrackpadTouchPhase {
    switch self {
      case .began: .began
      case .cancelled: .cancelled
      case .ended: .ended
      case .moved: .moved
      case .stationary: .stationary
      default: .none
    }
  }
}

public struct RawGesture: Identifiable, Hashable, Sendable {
  public let id: UUID
  public let phase: TrackpadGesturePhase
  public let touches: [MappedTouchPoint]
}

public struct TrackpadGesture: Identifiable, Hashable, Sendable {
  public let id: UUID
  public let type: GestureType
  public let phase: TrackpadGesturePhase
//  public let touches: [TouchPoint]
  
  public static let unknown = TrackpadGesture(id: UUID(), type: .unknown, phase: .none)
}

