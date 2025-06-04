//
//  Model+MappedPoints.swift
//  LilyPad
//
//  Created by Dave Coleman on 2/6/2025.
//

import CoreGraphics
import Foundation

public struct MappedTouchPointsBuilder {
  public let mappedTouches: [MappedTouchPoint]
  let mappedRect: CGRect
  
  public init(
    touches: Set<TouchPoint> = [],
    mappingRect: CGRect = .zero
  ) {
    let mapped = Self.mapTouches(touches, mappingRect: mappingRect)
    self.mappedTouches = mapped
    self.mappedRect = mappingRect
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
        pressure: touchPoint.pressure
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

public struct MappedTouchPoint: Identifiable, Codable, Equatable, Sendable, Hashable {
  public let id: Int
  public let phase: TouchPhase
  public var position: CGPoint
  public let timestamp: TimeInterval
  public let velocity: CGVector
  public let pressure: CGFloat
  
}
