//
//  TrackpadTouch.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import AppKit
import MemberwiseInit

@MemberwiseInit(.public)
public struct TouchPressure: Hashable {
  public var behavior: NSEvent.PressureBehavior
  public var value: CGFloat?
}

public struct TrackpadTouch: Identifiable, Hashable {
  public let id: Int
  public let position: CGPoint
  public let timestamp: TimeInterval
  public let pressure: TouchPressure
  
  public var velocity: CGVector
  public var previousPosition: CGPoint?
  public var previousTimestamp: TimeInterval?
  
  /// Initializer from an NSTouch, capturing its state at a specific moment
  public init(
    _ nsTouch: NSTouch,
    timestamp: TimeInterval,
    pressureBehaviour: NSEvent.PressureBehavior,
    pressureAmount: CGFloat,
    previousTouch: TrackpadTouch? = nil
  ) {
    // MARK: - NSTouch
    self.id = nsTouch.identity.hash
    self.position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      /// Flip Y to match SwiftUI coordinate system
      y: 1.0 - nsTouch.normalizedPosition.y
    )
    
    // MARK: - Timestamp
    self.timestamp = timestamp
    
    // MARK: - Pressure
    self.pressure = TouchPressure(
      behavior: pressureBehaviour,
      value: pressureAmount
    )
    
    /// Initialize with previous touch data if available
    self.previousPosition = previousTouch?.position
    self.previousTimestamp = previousTouch?.timestamp
    
    /// Calculate velocity if we have previous data
    if let prevPos = previousTouch?.position, let prevTime = previousTouch?.timestamp {
      let dx = position.x - prevPos.x
      let dy = position.y - prevPos.y
      let dt = timestamp - prevTime
      
      /// Avoid division by zero or very small time deltas
      if dt > 0.001 {
        self.velocity = CGVector(dx: dx / CGFloat(dt), dy: dy / CGFloat(dt))
      } else {
        self.velocity = CGVector.zero
      }
    } else {
      self.velocity = CGVector.zero
    }
  }
  /// The magnitude of the velocity vector (speed)
  public var speed: CGFloat {
    return sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
  }
  
  /// The direction of movement in radians
  public var direction: CGFloat {
    return atan2(velocity.dy, velocity.dx)
  }
}

extension TrackpadTouch {
  
  /// For Debugging — not sure if needed
  public init(
    id: Int,
    position: CGPoint,
    timestamp: TimeInterval
  ) {
    self.id = id
    self.position = position
    self.timestamp = timestamp
    
    self.velocity = .zero
    self.previousPosition = nil
    self.previousTimestamp = nil
  }
  
}

