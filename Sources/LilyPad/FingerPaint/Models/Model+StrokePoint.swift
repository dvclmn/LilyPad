//
//  Model+StrokePoint.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation

/// Velocity describes the motion between two sampled positions over time.
/// We're storing a motion vector associated with a timestamped position sample.
/// `velocity`: How fast the touch was moving when it arrived at `position`
public struct StrokePoint {
  public let position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector?
  
  private var _width: CGFloat? = nil
  
  public mutating func setCachedWidth(_ value: CGFloat) {
    _width = value
  }
  
  public func width(using model: StrokeEngine) -> CGFloat {
    _width ?? model.calculateWidth(for: velocity)
  }
}

//public struct StrokePoint {
//  public var position: CGPoint
//  public var width: CGFloat
//  public var timestamp: TimeInterval
//  public var velocity: CGVector
//  // more in future: pressure, force, tilt, etc
//  
//  /// Initialise from a `CGPoint`
//  init(
//    point: CGPoint,
//    width: CGFloat = 1,
//    timestamp: TimeInterval = 0,
//    velocity: CGVector = .zero
//  ) {
//    
//  }
//}
