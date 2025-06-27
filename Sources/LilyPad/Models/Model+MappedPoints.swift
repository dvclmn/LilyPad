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
  public let deviceSize: CGSize
  public let isResting: Bool

  /// This is stored here to allow subsequent remapping if needed
  public let mappedSize: CGSize

  init(
    id: Int,
    phase: TouchPhase,
    position: CGPoint,
    timestamp: TimeInterval,
    velocity: CGVector,
    pressure: CGFloat,
    deviceSize: CGSize,
    isResting: Bool,
    mappedSize: CGSize,
    
  ) {
    self.id = id
    self.phase = phase
    self.position = position
    self.timestamp = timestamp
    self.velocity = velocity
    self.pressure = pressure
    self.deviceSize = deviceSize
    self.isResting = isResting
    self.mappedSize = mappedSize
  }

  public init(
    current: any TrackpadTouch,
    updatedPosition: CGPoint,
    mappedSize: CGSize,
  ) {
    precondition(current.position.isNormalised, "Touch point must be normalised (0.0 to 1.0). Cannot perform mapping on a non-normalised point.")
    self.init(
      id: current.id,
      phase: current.phase,
      position: updatedPosition,
      timestamp: current.timestamp,
      velocity: current.velocity,
      pressure: current.pressure,
      deviceSize: current.deviceSize,
      isResting: current.isResting,
      mappedSize: mappedSize,
    )
  }

//  public init(
//    currentPoint: Self,
//    newMappingSize: CGSize,
//  ) {
//    let newPoint: CGPoint = currentPoint.position.remapped(
//      from: currentPoint.mappedSize.toCGRectZeroOrigin,
//      to: newMappingSize.toCGRectZeroOrigin
//    )
//    self.init(current: currentPoint, updatedPosition: newPoint, mappedSize: newMappingSize)
//  }
  
  /// Allows creation of a 'mapped' touch point for special case of
  /// a click-based point, when using the click + drag style drawing mode.
  /// As opposed to 'finger painting' trackpad style
  public init(clickTouch: TouchPoint) {
    self.init(
      id: clickTouch.id,
      phase: clickTouch.phase,
      position: clickTouch.position,
      timestamp: clickTouch.timestamp,
      velocity: clickTouch.velocity,
      pressure: clickTouch.pressure,
      deviceSize: clickTouch.deviceSize,
      isResting: clickTouch.isResting,
      mappedSize: CGSize(width: 1, height: 1)
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
    withTransform transform: CGAffineTransform,
  ) {
    let updatedPoint = currentPoint.position.applying(transform)
    self.init(
      id: currentPoint.id,
      phase: currentPoint.phase,
      position: updatedPoint,
      timestamp: currentPoint.timestamp,
      velocity: currentPoint.velocity,
      pressure: currentPoint.pressure,
      deviceSize: currentPoint.deviceSize,
      isResting: currentPoint.isResting,
      mappedSize: currentPoint.mappedSize
    )
  }
}

extension MappedTouchPoint {

}



