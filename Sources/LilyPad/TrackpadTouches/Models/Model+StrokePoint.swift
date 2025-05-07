//
//  Model+StrokePoint.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation
import MemberwiseInit

/// Velocity describes the motion between two sampled positions over time.
/// We're storing a motion vector associated with a timestamped position sample.
/// `velocity`: How fast the touch was moving when it arrived at `position`

@MemberwiseInit(.public)
public struct TouchPoint: Identifiable, Hashable, Codable {
  public let id: Int
  public let position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector
  public let pressure: CGFloat?

  @Init(.ignore) private var _width: CGFloat? = nil

  public mutating func setCachedWidth(_ value: CGFloat) {
    _width = value
  }

  public func width(
    using model: StrokeWidthHandler,
    config: StrokeConfiguration
  ) -> CGFloat {
    if let cachedWidth = _width {
      print("Used a cached width for this touch point.")
      return cachedWidth
    }
    let result = model.calculateStrokeWidth(
      speed: velocity.speed,
      pressure: pressure,
      config: config
    )
    return result
  }

  public var direction: CGFloat {
    return atan2(velocity.dy, velocity.dx)
  }
}

extension TouchPoint: CustomStringConvertible {
  public var description: String {
    "TouchPoint(position: \(position), timestamp: \(timestamp), velocity: \(velocity)),"
  }
}
