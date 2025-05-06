//
//  TrackpadTouch.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import AppKit
import MemberwiseInit

public struct TrackpadTouch: Identifiable, Hashable, Codable {
  public let id: Int
  public let position: CGPoint
  public let timestamp: TimeInterval
  public var velocity: CGVector
  
  /// Initializer from an NSTouch, capturing its state at a specific moment
  public init(
    id: Int,
    position: CGPoint,
    timestamp: TimeInterval,
    velocity: CGVector?,
  ) {
    self.id = id
    self.position = position
    self.timestamp = timestamp
    #warning("Not sure if falling back to zero velocity is correct, need to look into this")
    self.velocity = velocity ?? .zero
  }

  /// The direction of movement in radians
  public var direction: CGFloat {
    return atan2(velocity.dy, velocity.dx)
  }
}
