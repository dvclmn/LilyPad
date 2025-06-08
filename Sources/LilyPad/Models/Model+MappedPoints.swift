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
  public let mappedRect: CGRect
  
  init(
    id: Int,
    phase: TouchPhase,
    position: CGPoint,
    timestamp: TimeInterval,
    velocity: CGVector,
    pressure: CGFloat,
    mappedRect: CGRect
  ) {
    self.id = id
    self.phase = phase
    self.position = position
    self.timestamp = timestamp
    self.velocity = velocity
    self.pressure = pressure
    self.mappedRect = mappedRect
  }
  
  public init(
    previousPoint: Self,
    newMappingRect: CGRect,
  ) {
    let newPoint: CGPoint = previousPoint.position.remapped(
      from: previousPoint.mappedRect,
      to: newMappingRect
    )
    self.id = previousPoint.id
    self.phase = previousPoint.phase
    self.position = newPoint
    self.timestamp = previousPoint.timestamp
    self.velocity = previousPoint.velocity
    self.pressure = previousPoint.pressure
    self.mappedRect = newMappingRect
  }
}

extension MappedTouchPoint: CustomStringConvertible {
  public var description: String {
    return TouchPoint.generateDescription(for: self)
  }
}

public struct MappedTouchPointsBuilder {
  public let mappedTouches: [MappedTouchPoint]
  let mappedRect: CGRect

  public init(
    touches: Set<TouchPoint>,
    in mappingRect: CGRect
  ) {
    let mapped = Self.mapTouches(touches, mappingRect: mappingRect)
    self.mappedTouches = mapped
    self.mappedRect = mappingRect
  }

  public init(
    touches: [TouchPoint],
    in mappingRect: CGRect
  ) {
    self.init(touches: Set(touches), in: mappingRect)
  }

  private static func mapTouches(
    _ touches: Set<TouchPoint>,
    mappingRect: CGRect
  ) -> [MappedTouchPoint] {
    let mapped: [MappedTouchPoint] = touches.map { touchPoint in
      let newPosition = touchPoint.position.mapped(to: mappingRect)
      return MappedTouchPoint(
        id: touchPoint.id,
        phase: touchPoint.phase,
        position: newPosition,
        timestamp: touchPoint.timestamp,
        velocity: touchPoint.velocity,
        pressure: touchPoint.pressure,
        mappedRect: mappingRect
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
