//
//  Models.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI


/// Represents a touch stroke with a series of points and widths
public struct TouchStroke: Identifiable {
  public let id: UUID
  public var points: [CGPoint]
  public var widths: [CGFloat]
  public var color: Color
  
  public init(
    id: UUID = UUID(),
    points: [CGPoint],
    widths: [CGFloat],
    color: Color = .black
  ) {
    self.id = id
    self.points = points
    self.widths = widths
    self.color = color
  }
  
  /// Add a point to the stroke with a specified width
  public mutating func addPoint(
//    lastPoint: CGPoint,
    _ point: CGPoint,
//    touch: TrackpadTouch,
    width: CGFloat
  ) {
    

//      let distance = hypot(point.x - lastPoint.x, point.y - lastPoint.y)
//      let shouldAddPoint = distance > minDistanceThreshold || touch.speed < minSpeedForSparseSampling
//      if shouldAddPoint {
//        stroke.addPoint(touchPosition, width: width)
//      }
//
//    
    points.append(point)
    widths.append(width)
  }
  
  public static let exampleStrokes: [TouchStroke] = [
    .init(
      points: [
        CGPoint.zero,
        CGPoint(x: 100, y: 100),
        CGPoint(x: 200, y: 0),
        CGPoint(x: 300, y: 100),
        CGPoint(x: 400, y: 200),
        CGPoint(x: 500, y: 100),
        CGPoint(x: 600, y: 200),
      ],
      widths: [2, 6, 10, 12, 8, 7, 3],
      color: .green,
    )
  ]
}
