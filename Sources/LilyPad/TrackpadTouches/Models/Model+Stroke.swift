//
//  Models.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI
import MemberwiseInit

/// Represents a touch stroke with a series of points and widths
@MemberwiseInit(.public)
public struct TouchStroke: Identifiable {
  public let id: UUID = UUID()
  public var points: [StrokePoint]
  public var colour: Color

  /// Add a point to the stroke with a specified width
  public mutating func addPoint(
    _ point: StrokePoint,
//    width: CGFloat
  ) {
    points.append(point)
//    widths.append(width)
  }
  
  public var cgPoints: [CGPoint] {
    return points.map(\.position)
  }

  public func getWidthAtPoint(_ point: CGPoint, model: StrokeWidthHandler) -> CGFloat? {
    let targetStrokePoint = points.first { strokePoint in
      strokePoint.position == point
    }
    let width = targetStrokePoint?.width(using: model)
    
    return width
  }
  
  public subscript (pointAtIndex index: Int) -> CGPoint {
    let result = points[index].position
    return result
  }
  
//  public static let exampleStrokes: [TouchStroke] = [
//    .init(
//      points: [
//        CGPoint.zero,
//        CGPoint(x: 100, y: 100),
//        CGPoint(x: 200, y: 0),
//        CGPoint(x: 300, y: 100),
//        CGPoint(x: 400, y: 200),
//        CGPoint(x: 500, y: 100),
//        CGPoint(x: 600, y: 200),
//      ],
//      widths: [2, 6, 10, 12, 8, 7, 3],
//      color: .green,
//    )
//  ]
}

enum StrokeState {
  case active
  case completed
  case optimized
}

struct StrokeWrapper {
  var stroke: TouchStroke
  var state: StrokeState
}
