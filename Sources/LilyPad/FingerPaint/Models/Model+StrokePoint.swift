//
//  Model+StrokePoint.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation

public struct StrokePoint {
  public var position: CGPoint
  public var width: CGFloat
  public var timestamp: TimeInterval
  public var velocity: CGVector
  // more in future: pressure, force, tilt, etc
  
  /// Initialise from a `CGPoint`
  init(
    point: CGPoint,
    width: CGFloat = 1,
    timestamp: TimeInterval = 0,
    velocity: CGVector = .zero
  ) {
    
  }
}
