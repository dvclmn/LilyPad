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



/// The ID comes from `NSTouch` identity:
/// ```
/// var identity: any NSCopying & NSObjectProtocol { get }
/// ```
/// and is constructed as below:
/// ```
/// func id(for touch: NSTouch) -> Int {
///   ObjectIdentifier(touch.identity).hashValue
/// }
/// ```
public struct TouchPoint: Identifiable, Sendable, Hashable, Equatable, Codable {
  public let id: Int
  public let phase: TrackpadTouchPhase
  /// This is normalised, comes from `NSTouch.normalizedPosition`
  public let position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector
  public let pressure: CGFloat

  public init(
    id: Int,
    phase: TrackpadTouchPhase,
    position: CGPoint,
    timestamp: TimeInterval,
    velocity: CGVector,
    pressure: CGFloat,
  ) {
    self.id = id
    self.phase = phase
    self.position = position
    self.timestamp = timestamp
    self.velocity = velocity
    self.pressure = pressure
  }
}

extension Array where Element == TouchPoint {
  
  public func mappedPoints(in rect: CGRect) -> [TouchPoint] {
    let result = self.map { point in
      point.mapPoint(to: rect)
    }
    return result
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

  func mapPoint(to destination: CGRect) -> TouchPoint {
    let mappedPoint = self.position.mapped(to: destination)
    return TouchPoint(
      id: self.id,
      phase: self.phase,
      position: mappedPoint,
      timestamp: self.timestamp,
      velocity: self.velocity,
      pressure: self.pressure
    )
  }
  
//  public func cgPointMapped(to destination: CGRect) -> CGPoint {
//    return self.position.mapped(to: destination)
//  }
//  
//  public func mapPoint(to destination: CGRect) -> TouchPoint {
//    let mappedPoint: CGPoint = self.cgPointMapped(to: destination)
//    let newTouchPoint = TouchPoint(
//      id: self.id,
//      phase: self.phase,
//      position: mappedPoint,
//      timestamp: self.timestamp,
//      pressure: self.pressure
//    )
//    return newTouchPoint
//  }

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
    position: CGPoint(x: 0.2, y: 0.6),
    timestamp: 1,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.5
  )

  public static let example02 = TouchPoint(
    id: 2,
    phase: .moved,
    position: CGPoint(x: 0.4, y: 0.4),
    timestamp: 2,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.2
  )
  
  public static let topLeading = TouchPoint(
    id: 3,
    phase: .moved,
    position: CGPoint(x: 0, y: 0),
    timestamp: 6,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.5
  )
  
  public static let topTrailing = TouchPoint(
    id: 4,
    phase: .moved,
    position: CGPoint(x: 1.0, y: 0),
    timestamp: 10,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.5
  )
  public static let bottomLeading = TouchPoint(
    id: 5,
    phase: .moved,
    position: CGPoint(x: 0, y: 1.0),
    timestamp: 16,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.5
  )
  public static let bottomTrailing = TouchPoint(
    id: 5,
    phase: .moved,
    position: CGPoint(x: 1.0, y: 1.0),
    timestamp: 19,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.5
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
