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

public protocol TrackpadTouch: Identifiable, Sendable, Hashable, Equatable, Codable {
  var id: Int { get }
  var phase: TouchPhase { get }
  var position: CGPoint { get set }
  var timestamp: TimeInterval { get }
  var velocity: CGVector { get }
  var pressure: CGFloat { get }
}

public struct TouchPoint: TrackpadTouch {
  public let id: Int
  public let phase: TouchPhase
  /// This is normalised, comes from `NSTouch.normalisedPosition`
  public var position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector
  public let pressure: CGFloat

  public init(
    id: Int,
    phase: TouchPhase,
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

//  public mutating func updatedPointPosition(_ newPosition: CGPoint) {
//    self.position = newPosition
//  }
//  public func withUpdatedPosition(_ newPosition: CGPoint) -> TouchPoint {
////  public func newWithMappedPoint(to destination: CGRect) -> TouchPoint {
////    let mappedPoint = self.position.mapped(to: destination)
//    return TouchPoint(
//      id: self.id,
//      phase: self.phase,
//      position: newPosition,
//      timestamp: self.timestamp,
//      velocity: self.velocity,
//      pressure: self.pressure
//    )
//  }

  /// Whether this touch has meaningful pressure data
  public var hasPressure: Bool {
    return pressure > 0
  }


  /// Normalized pressure between 0 and 1 for drawing operations
  public var normalisedPressure: CGFloat {
    return min(max(pressure, 0), 1)
  }
  
  public static func generateDescription(for trackpadTouch: any TrackpadTouch) -> String {

    let isMapped: Bool = trackpadTouch as? MappedTouchPoint != nil
    return """
    /////
    Trackpad Touch \(isMapped ? "Mapped" : "")
      - ID: \(trackpadTouch.id)
      - Phase: \(trackpadTouch.phase.rawValue)
      - Position: \(trackpadTouch.position.displayString)
      - Timestamp: \(trackpadTouch.timestamp.displayString)
      - Velocity: \(trackpadTouch.velocity.displayString)
      - Pressure: \(trackpadTouch.pressure.displayString)
    /////
    
    
    """
  }
  
}

extension TouchPoint: CustomStringConvertible {
  public var description: String {
    return Self.generateDescription(for: self)
  }
}


extension Array where Element == TouchPoint {
//  public func mappedPoints(in rect: CGRect) -> [TouchPoint] {
//    let result = self.map { point in
//      point.mapPoint(to: rect)
//    }
//    return result
//  }

  public func hasFourPoints() -> Bool {
    return self.count == 4
  }
}

extension CatmullRomSegment {
  public init?(from touchPoints: [TouchPoint]) {
    guard touchPoints.hasFourPoints() else {
      print("Minimum 4 points required for CatmullRomSegment")
      return nil
    }
    let (p0, p1, p2, p3) = (
      touchPoints[0].position,
      touchPoints[1].position,
      touchPoints[2].position,
      touchPoints[3].position
    )
    self.init(p0: p0, p1: p1, p2: p2, p3: p3)
  }
}
