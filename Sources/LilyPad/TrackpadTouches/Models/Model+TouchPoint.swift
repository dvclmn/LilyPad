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
