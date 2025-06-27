//
//  Model+StrokePoint.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import AppKit
import BaseHelpers
import Foundation
import MemberwiseInit

public struct TouchPoint: TrackpadTouch {
  public let id: Int
  public var phase: TouchPhase

  /// This is normalised, comes from `NSTouch.normalisedPosition`
  public var position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector
  public let pressure: CGFloat
  public let deviceSize: CGSize
  public let isResting: Bool

  public init(
    id: Int,
    phase: TouchPhase,
    position: CGPoint,
    timestamp: TimeInterval,
    velocity: CGVector,
    pressure: CGFloat,
    deviceSize: CGSize,
    isResting: Bool
  ) {
    self.id = id
    self.phase = phase
    self.position = position
    self.timestamp = timestamp
    self.velocity = velocity
    self.pressure = pressure
    self.deviceSize = deviceSize
    self.isResting = isResting
  }

  /// Create from AppKit native `NSTouch`
  public init(
    from nsTouch: NSTouch,
    touchID: Int,
    phase: NSTouch.Phase,
    timestamp: TimeInterval,  // From NSEvent.timestamp
    pressure: CGFloat,
    deviceSize: CGSize,
    isResting: Bool
  ) {
    let position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      y: 1.0 - nsTouch.normalizedPosition.y  // Flip Y
    )
    self.init(
      id: touchID,
      phase: phase.toDomainPhase,
      position: position,
      timestamp: timestamp,
      velocity: .zero,  // This will be enriched in next step
      pressure: pressure,
      deviceSize: deviceSize,
      isResting: isResting
    )
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
      deviceSize: deviceSize,
      isResting: isResting
    )
  }


  public static func generateDescription(for touch: any TrackpadTouch) -> String {

    let isMapped: Bool = touch as? MappedTouchPoint != nil

    return """
      /////
      Trackpad Touch \(isMapped ? "Mapped" : "")
        - ID: \(touch.id)
        - Phase: \(touch.phase.rawValue)
        - Position: \(touch.position.displayString)
        - Timestamp: \(touch.timestamp.displayString)
        - Velocity: \(touch.velocity.displayString)
        - Pressure: \(touch.pressure.displayString)
        - Device Size: \(touch.deviceSize.displayString)
        - Is Resting?: \(touch.isResting)
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
