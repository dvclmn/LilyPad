//
//  Model+MappedPoints.swift
//  LilyPad
//
//  Created by Dave Coleman on 2/6/2025.
//

import CoreGraphics

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
  
//  public var touchCount: Int {
//    self.mappedTouches.count
//  }
  
  private static func mapTouches(
    _ touches: Set<TouchPoint>,
    mappingRect: CGRect
  ) -> [MappedTouchPoint] {
    let mapped: [MappedTouchPoint] = touches.map { touchPoint in
      let newPosition = touchPoint.position.mapped(to: mappingRect)
      return MappedTouchPoint(
        id: touchPoint.id,
        position: newPosition,
        velocity: touchPoint.velocity,
        pressure: touchPoint.pressure
      )
    }
    return mapped
  }
  
//  public var mappedTouchPoints: [TouchPoint] {
//    let mapped = touches.map(\.touchPoint)
////    let mapped = mappedTouches.map(\.touchPoint)
//    return mapped
//  }
  
  
  public func mappedTouch(withID id: TouchPoint.ID) -> MappedTouchPoint? {
    guard let touch = mappedTouches.first(where: { $0.id == id }) else {
      print("Couldn't find TouchPoint matching id: \(id)")
      return nil
    }
    return touch
    
//    let newPosition: CGPoint = touch.position.mapped(to: mappedRect)
//    let newTouchPoint = touch.withUpdatedPosition(newPosition)
    
//    return MappedTouchPoint(
//      touchPoint: newTouchPoint
//    )
  }
  
//  public func mappedTouch(withID id: TouchPoint.ID) -> MappedTouchPoint? {
//    guard let touch = touches.first(where: { $0.touchPoint.id == id }) else {
//      print("Couldn't find TouchPoint matching id: \(id)")
//      return nil
//    }
//    let newPosition: CGPoint = touch.position.mapped(to: mappedRect)
//    let newTouchPoint = touch.withUpdatedPosition(newPosition)
//    
//    return MappedTouchPoint(
//      touchPoint: newTouchPoint
//    )
//  }
}

public struct MappedTouchPoint: Identifiable, Codable, Equatable {
  public let id: Int
  public var position: CGPoint
  public let velocity: CGVector
  public let pressure: CGFloat
  
}
