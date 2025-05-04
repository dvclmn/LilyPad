//
//  Models.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI

/// Represents a normalized touch on the trackpad
public struct TrackpadTouch: Identifiable, Hashable {
  public let id: Int
  public let position: CGPoint
  public let timestamp: TimeInterval
  
  public var velocity: CGVector
  public var previousPosition: CGPoint?
  public var previousTimestamp: TimeInterval?

  /// Initializer from an NSTouch, capturing its state at a specific moment
  public init(_ nsTouch: NSTouch, previousTouch: TrackpadTouch? = nil) {
    self.id = nsTouch.identity.hash
    self.position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      /// Flip Y to match SwiftUI coordinate system
      y: 1.0 - nsTouch.normalizedPosition.y
    )
    self.timestamp = Date().timeIntervalSince1970
    
    /// Initialize with previous touch data if available
    self.previousPosition = previousTouch?.position
    self.previousTimestamp = previousTouch?.timestamp
    
//    if let previousTouch {
//      print("Previous touch `\(previousTouch)`")
//    }
//    if let previousPosition {
//      print("Previous position `\(previousPosition)`")
//    }
//    
//    if let previousTimestamp {
//      print("Previous Timestamp `\(previousTimestamp)`")
//    }
    
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
  /// For Debugging
  public init(
    id: Int,
    position: CGPoint,
    time: TimeInterval
  ) {
    self.id = id
    self.position = position
    self.timestamp = time
    
    self.velocity = .zero
    self.previousPosition = nil
    self.previousTimestamp = nil
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


/// Represents a touch stroke with a series of points and widths
public struct TouchStroke: Identifiable {
  public let id: UUID
  public var points: [CGPoint]
  public var widths: [CGFloat]
  public var color: Color

  public init(
    id: UUID = UUID(),
    points: [CGPoint],
    widths: [CGFloat],
    color: Color = .black
  ) {
    self.id = id
    self.points = points
    self.widths = widths
    self.color = color
  }
  
  /// Add a point to the stroke with a specified width
  public mutating func addPoint(
    _ point: CGPoint,
    width: CGFloat
  ) {
    points.append(point)
    widths.append(width)
  }
  
  public static let exampleStrokes: [TouchStroke] = [
    .init(
      points: [
        CGPoint.zero,
        CGPoint(x: 100, y: 100),
        CGPoint(x: 200, y: 0),
        CGPoint(x: 300, y: 100),
        CGPoint(x: 400, y: 200),
        CGPoint(x: 500, y: 100),
        CGPoint(x: 600, y: 200),
      ],
      widths: [2, 6, 10, 14, 18, 22, 26],
      color: .green,
    )
  ]
}
