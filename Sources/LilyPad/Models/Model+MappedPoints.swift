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
    currentPoint: Self,
    newMappingSize: CGSize,
  ) {
    let newPoint: CGPoint = currentPoint.position.remapped(
      from: currentPoint.mappedSize.toCGRectZeroOrigin,
      to: newMappingSize.toCGRectZeroOrigin
    )
    self.init(current: currentPoint, updatedPosition: newPoint, mappedSize: newMappingSize)
//    self.init(
//      id: currentPoint.id,
//      phase: currentPoint.phase,
//      position: newPoint,
//      timestamp: currentPoint.timestamp,
//      velocity: currentPoint.velocity,
//      pressure: currentPoint.pressure,
//      mappedSize: newMappingSize,
//    )
  }
  
  public init(
    current: any TrackpadTouch,
    updatedPosition: CGPoint,
    mappedSize: CGSize,
  ) {
    self.init(
      id: current.id,
      phase: current.phase,
      position: updatedPosition,
      timestamp: current.timestamp,
      velocity: current.velocity,
      pressure: current.pressure,
      mappedSize: mappedSize,
    )
  }
  
//  public init(
//    currentPoint: MappedTouchPoint,
//    newMappingSize: CGSize,
//  ) {
//    let newPoint: CGPoint = currentPoint.position.remapped(
//      from: currentPoint.mappedSize.toCGRectZeroOrigin,
//      to: newMappingSize.toCGRectZeroOrigin
//    )
//    self.init(current: currentPoint, updatedPosition: newPoint, mappedSize: newMappingSize)
////    self.init(
////      id: previousPoint.id,
////      phase: previousPoint.phase,
////      position: newPoint,
////      timestamp: previousPoint.timestamp,
////      velocity: previousPoint.velocity,
////      pressure: previousPoint.pressure,
////      mappedSize: newMappingSize,
////    )
//  }

  public init(
    currentPoint: Self,
    with transform: CGAffineTransform,
  ) {
    let updatedPoint = currentPoint.position.applying(transform)
    self.init(
      id: currentPoint.id,
      phase: currentPoint.phase,
      position: updatedPoint,
      timestamp: currentPoint.timestamp,
      velocity: currentPoint.velocity,
      pressure: currentPoint.pressure,
      mappedSize: currentPoint.mappedSize
    )
  }
}

extension MappedTouchPoint {

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

extension Set where Element == MappedTouchPoint {
  public var cgPoints: [CGPoint] {
    return self.map(\.position)
  }
}
