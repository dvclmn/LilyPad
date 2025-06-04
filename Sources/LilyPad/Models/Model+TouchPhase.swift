//
//  Model+TouchPhase.swift
//  LilyPad
//
//  Created by Dave Coleman on 4/6/2025.
//

import AppKit

public enum TouchPhase: String, Sendable, Equatable, Codable {
  case none
  case began
  case moved
  case stationary
  case ended
  case cancelled
}

extension NSTouch.Phase {
  var toDomainPhase: TouchPhase {
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
