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
public struct StrokePoint: Identifiable, Codable {
  public let id: UUID
  public let position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector?
  public let pressure: CGFloat?

  @Init(.ignore) private var _width: CGFloat? = nil

  public mutating func setCachedWidth(_ value: CGFloat) {
    _width = value
  }

  public func width(using model: StrokeWidthHandler, strokeConfig: StrokeConfig) -> CGFloat? {
    if let cachedWidth = _width {
      return cachedWidth
    }
    let result = model.calculateStrokeWidth(speed: velocity?.speed, pressure: pressure, strokeConfig: strokeConfig)
    return result
  }
}

extension StrokePoint: CustomStringConvertible {
  public var description: String {
    "StrokePoint(position: \(position), timestamp: \(timestamp), velocity: \(velocity ?? .zero)),"
  }
}
