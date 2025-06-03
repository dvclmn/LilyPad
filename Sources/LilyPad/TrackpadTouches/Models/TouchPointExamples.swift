//
//  TouchPointExamples.swift
//  LilyPad
//
//  Created by Dave Coleman on 31/5/2025.
//

import Foundation

extension MappedTouchPoint {
  
  public static func examplePoints(mappingRect: CGRect) -> [MappedTouchPoint] {
    let normalisedPoints = TouchPoint.allExamplePoints

    let builder = MappedTouchPointsBuilder(
      touches: Set(normalisedPoints),
      mappingRect: mappingRect
    )
    return builder.mappedTouches
    
  }
  //    example01,
//    example02,
//    topLeading,
//    topTrailing,
//    bottomLeading,
//    bottomTrailing
//  ]
}
extension TouchPoint {
  
  public static let allExamplePoints: [TouchPoint] = [
    example01,
    example02,
    topLeading,
    topTrailing,
    bottomLeading,
    bottomTrailing
  ]
  
  public static let example01 = TouchPoint(
    id: 1,
    phase: .ended,
    position: CGPoint(x: 0.2, y: 0.6),
    timestamp: 1,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.5
  )
  
  public static let example02 = TouchPoint(
    id: 2,
    phase: .ended,
    position: CGPoint(x: 0.4, y: 0.4),
    timestamp: 2,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.2
  )
  
  public static let topLeading = TouchPoint(
    id: 3,
    phase: .ended,
    position: CGPoint(x: 0, y: 0),
    timestamp: 6,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.5
  )
  
  public static let topTrailing = TouchPoint(
    id: 4,
    phase: .ended,
    position: CGPoint(x: 1.0, y: 0),
    timestamp: 10,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.5
  )
  public static let bottomLeading = TouchPoint(
    id: 5,
    phase: .ended,
    position: CGPoint(x: 0, y: 1.0),
    timestamp: 16,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.5
  )
  public static let bottomTrailing = TouchPoint(
    id: 6,
    phase: .ended,
    position: CGPoint(x: 1.0, y: 1.0),
    timestamp: 19,
    velocity: CGVector(dx: 2, dy: 9),
    pressure: 0.5
  )

}
