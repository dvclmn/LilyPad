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

public struct MappedTouchPointsBuilder {
  public let mappedTouches: [MappedTouchPoint]
  let mappedSize: CGSize

  public init(
    touches: Set<TouchPoint>,
    in mappingSize: CGSize
  ) {
    let mapped = Self.mapTouches(touches, mappingSize: mappingSize)
    self.mappedTouches = mapped
    self.mappedSize = mappingSize
  }

  public init(
    touches: [TouchPoint],
    in mappingSize: CGSize
  ) {
    self.init(touches: Set(touches), in: mappingSize)
  }

  private static func mapTouches(
    _ touches: Set<TouchPoint>,
    mappingSize: CGSize
  ) -> [MappedTouchPoint] {
    let mapped: [MappedTouchPoint] = touches.map { touchPoint in
      let newPosition = touchPoint.position.mapped(to: mappingSize.toCGRectZeroOrigin)
      return MappedTouchPoint(
        id: touchPoint.id,
        phase: touchPoint.phase,
        position: newPosition,
        timestamp: touchPoint.timestamp,
        velocity: touchPoint.velocity,
        pressure: touchPoint.pressure,
        mappedSize: mappingSize
      )
    }
    return mapped
  }

  public func mappedTouch(withID id: TouchPoint.ID) -> MappedTouchPoint? {
    guard let touch = mappedTouches.first(where: { $0.id == id }) else {
      print("Couldn't find TouchPoint matching id: \(id)")
      return nil
    }
    return touch
  }

}

extension Array where Element == MappedTouchPoint {
  public var cgPoints: [CGPoint] {
    return self.map(\.position)
  }
}
