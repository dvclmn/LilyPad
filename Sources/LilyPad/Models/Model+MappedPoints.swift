//
//  Model+MappedPoints.swift
//  LilyPad
//
//  Created by Dave Coleman on 2/6/2025.
//

import CoreGraphics
import Foundation

public struct MappedTouchPoint: TrackpadTouch {
  public let id: Int
  public let phase: TouchPhase
  public var position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector
  public let pressure: CGFloat

  /// This is stored here to allow subsequent remapping if needed
  public let mappedSize: CGSize

  init(
    id: Int,
    phase: TouchPhase,
    position: CGPoint,
    timestamp: TimeInterval,
    velocity: CGVector,
    pressure: CGFloat,
    mappedSize: CGSize
  ) {
    self.id = id
    self.phase = phase
    self.position = position
    self.timestamp = timestamp
    self.velocity = velocity
    self.pressure = pressure
    self.mappedSize = mappedSize
  }

  public init(
    previousPoint: Self,
    newMappingSize: CGSize,
  ) {
    let newPoint: CGPoint = previousPoint.position.remapped(
      from: previousPoint.mappedSize.toCGRectZeroOrigin,
      to: newMappingSize.toCGRectZeroOrigin
    )
    self.id = previousPoint.id
    self.phase = previousPoint.phase
    self.position = newPoint
    self.timestamp = previousPoint.timestamp
    self.velocity = previousPoint.velocity
    self.pressure = previousPoint.pressure
    self.mappedSize = newMappingSize
  }
}

extension MappedTouchPoint: CustomStringConvertible {
  public var description: String {
    return TouchPoint.generateDescription(for: self)
  }
}

extension Array where Element == MappedTouchPoint {
  public var cgPoints: [CGPoint] {
    return self.map(\.position)
  }
}
