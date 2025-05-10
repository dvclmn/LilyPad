//
//  Model+StrokePoint.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import BaseHelpers
import Foundation
import MemberwiseInit
import CoreGraphics

/// Velocity describes the motion between two sampled positions over time.
/// We're storing a motion vector associated with a timestamped position sample.
/// `velocity`: How fast the touch was moving when it arrived at `position`


public struct TouchPoint: Identifiable, Sendable, Hashable, Equatable, Codable {
  public let id: Int

  /// This is normalised, comes from `NSTouch.normalizedPosition`
  public let position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector
  public let pressure: CGFloat

  public init(
    id: Int,
    position: CGPoint,
    timestamp: TimeInterval,
    velocity: CGVector = .zero,
    pressure: CGFloat,
  ) {
    self.id = id
    self.position = position
    self.timestamp = timestamp
    self.pressure = pressure
    self.velocity = velocity
  }


  public func withVelocity(_ velocity: CGVector) -> TouchPoint {
    TouchPoint(
      id: id,
      position: position,
      timestamp: timestamp,
      velocity: velocity,
      pressure: pressure,
    )
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
extension TouchPoint {
  public static let example01 = TouchPoint(
    id: 1,
    position: CGPoint.quickPreset01,
    timestamp: 1,
    pressure: 0.5
  )
  
  public static let example02 = TouchPoint(
    id: 2,
    position: CGPoint.quickPreset02,
    timestamp: 2,
    pressure: 0.2
  )
  
}
extension TouchPoint: CustomStringConvertible {
  public var description: String {
    """
    /////
    TouchPoint
      - ID: \(id)
      - Position: \(position.displayString)
      - Timestamp: \(timestamp.displayString)
      - Velocity: \(velocity.displayString)
      - Pressure: \(pressure.displayString)
    /////
    
    
    """
  }
}
