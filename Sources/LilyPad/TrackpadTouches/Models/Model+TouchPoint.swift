//
//  Model+StrokePoint.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import BaseHelpers
import CoreGraphics
import Foundation
import MemberwiseInit

/// Velocity describes the motion between two sampled positions over time.
/// We're storing a motion vector associated with a timestamped position sample.
/// `velocity`: How fast the touch was moving when it arrived at `position`


public struct TouchPoint: Identifiable, Sendable, Hashable, Equatable, Codable {
  
  /// This comes from `NSTouch` identity:
  /// ```
  /// var identity: any NSCopying & NSObjectProtocol { get }
  /// ```
  /// and is constructed as below:
  /// ```
  /// func id(for touch: NSTouch) -> Int {
  ///   ObjectIdentifier(touch.identity).hashValue
  /// }
  /// ```
  public let id: Int
  public let phase: TrackpadGesturePhase
  /// This is normalised, comes from `NSTouch.normalizedPosition`
  public let position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector
  public let pressure: CGFloat

  public init(
    id: Int,
    phase: TrackpadGesturePhase,
    position: CGPoint,
    timestamp: TimeInterval,
    velocity: CGVector = .zero,
    pressure: CGFloat,
  ) {
    self.id = id
    self.phase = phase
    self.position = position
    self.timestamp = timestamp
    self.pressure = pressure
    self.velocity = velocity
  }
}

extension TouchPoint {
  public func withVelocity(_ velocity: CGVector) -> TouchPoint {
    TouchPoint(
      id: id,
      phase: phase,
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


  public static let example01 = TouchPoint(
    id: 1,
    phase: .moved,
    position: CGPoint.quickPreset01,
    timestamp: 1,
    pressure: 0.5
  )

  public static let example02 = TouchPoint(
    id: 2,
    phase: .moved,
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
