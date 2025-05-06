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
public struct StrokePoint: Identifiable {
  public let id: UUID = UUID()
  public let position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector?

  @Init(.ignore) private var _width: CGFloat? = nil

  public mutating func setCachedWidth(_ value: CGFloat) {
    _width = value
  }

  /// Note: currently used by `StrokeRenderer`
  public func width(using model: StrokeWidthHandler) -> CGFloat? {

    guard let speed = velocity?.speed else {
      print("Couldn't get velocity for StrokePoint with ID: `\(id)` and position: `\(position)`.")
      return nil
    }

    guard let cachedWidth = _width else {
      return model.calculateStrokeWidth(for: speed)
    }
    return cachedWidth
  }
}
//extension StrokePoint {
//  let exampleStroke
//}

extension StrokePoint: CustomStringConvertible {
  public var description: String {
    "StrokePoint(position: \(position), timestamp: \(timestamp), velocity: \(velocity ?? .zero)),"
  }
}
