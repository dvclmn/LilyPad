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

public enum TrackpadGesturePhase: String, Sendable, Equatable {
  case none
  case began
  case moved
  case ended
  case cancelled
}

