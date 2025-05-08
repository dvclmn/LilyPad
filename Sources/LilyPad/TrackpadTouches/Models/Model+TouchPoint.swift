//
//  Model+StrokePoint.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation
import MemberwiseInit
import BaseHelpers

/// Velocity describes the motion between two sampled positions over time.
/// We're storing a motion vector associated with a timestamped position sample.
/// `velocity`: How fast the touch was moving when it arrived at `position`

@MemberwiseInit(.public)
public struct TouchPoint: Identifiable, Sendable, Hashable, Equatable, Codable {
  public let id: Int
  
  /// This is normalised, comes from `NSTouch.normalizedPosition`
  public let position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector
  public let pressure: CGFloat

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
  
  public func mapPoint(to destination: CGRect) -> CGPoint {
    return self.position.mapped(to: destination)
  }
  
  /// Whether this touch has meaningful pressure data
  public var hasPressure: Bool {
    return pressure > 0
  }
  
  /// Normalized pressure between 0 and 1 for drawing operations
  public var normalizedPressure: CGFloat {
    return min(max(pressure, 0), 1)
  }
}

//extension TouchPoint {
//  public static let exampleTouch = TouchPoint(
//    id: 3,
//    position: CGPoint(x: 10, y: 20),
//    timestamp: TimeInterval(3),
//    velocity: .zero,
//    pressure: nil
//  )
//}

extension TouchPoint: CustomStringConvertible {
  public var description: String {
    """
    TouchPoint
      - ID: \(id)
      - Position: \(position.displayString)
      - Timestamp: \(timestamp.displayString)
      - Velocity: \(velocity.displayString)
      - Pressure: \(pressure.displayString)
    """
  }
}
