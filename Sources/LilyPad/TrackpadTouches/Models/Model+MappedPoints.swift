//
//  Model+MappedPoints.swift
//  LilyPad
//
//  Created by Dave Coleman on 2/6/2025.
//

import CoreGraphics

public struct MappedTouchPoints {
  private let touches: Set<TouchPoint>
  let mappedRect: CGRect
  
  public init(
    touches: Set<TouchPoint> = [],
    mappedRect: CGRect = .zero
  ) {
    self.touches = touches
    self.mappedRect = mappedRect
  }
  
  public var touchCount: Int {
    self.touches.count
  }
  
  public var mappedTouches: [MappedTouchPoint] {
    let allMapped: [MappedTouchPoint] = touches.map { touchPoint in
      let position = touchPoint.position.mapped(to: mappedRect)
      let newTouchPoint = touchPoint.withUpdatedPosition(position)
      return MappedTouchPoint(touchPoint: newTouchPoint)
    }
    return allMapped
  }
  
  public var mappedTouchPoints: [TouchPoint] {
    let mapped = mappedTouches.map(\.touchPoint)
    return mapped
  }
  
  public func mappedTouch(withID id: TouchPoint.ID) -> MappedTouchPoint? {
    guard let touch = touches.first(where: { $0.id == id }) else {
      print("Couldn't find TouchPoint matching id: \(id)")
      return nil
    }
    let newPosition: CGPoint = touch.position.mapped(to: mappedRect)
    let newTouchPoint = touch.withUpdatedPosition(newPosition)
    
    return MappedTouchPoint(
      touchPoint: newTouchPoint
    )
  }
}

public struct MappedTouchPoint {
  public let touchPoint: TouchPoint
}
