//
//  Models.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import MemberwiseInit
import SwiftUI
import BaseStyles

/// Represents a touch stroke with a series of points and widths
@MemberwiseInit(.public)
public struct TouchStroke: Identifiable, Codable, Equatable {
  public let id: UUID
//  public var points: [TouchPoint]
  public var colour: Swatch
  
  /// These are the *original* points recieved, before filtering.
  /// Used for debugging only
  #warning("APPEND POINTS TO THIS")
  public var pointsOriginal: [TouchPoint] = []

  /// Add a point to the stroke with a specified width
//  public mutating func addPoint(_ point: StrokePoint) {
//    points.append(point)
//  }
  
  public mutating func addPoint(
    _ point: TouchPoint
//    kind: StrokePointType
  ) {
    pointsOriginal.append(point)
//    switch kind {
//      case .pointsFiltered(let newPoints):
//        points.append(newPoints)
//        
//      case .pointsOriginal(let newPoints):
//        pointsOriginal.append(newPoints)
//    }
  }

  public var cgPoints: [CGPoint] {
    return pointsOriginal.map(\.position)
  }

//  public subscript(pointAtIndex index: Int) -> CGPoint {
//    let result = points[index].position
//    return result
//  }
}

extension TouchStroke {
  public func filteredPoints(using config: PointConfig, engine: StrokeEngine) -> [TouchPoint] {
    engine.filterPoints(from: pointsOriginal, pointConfig: config)
  }
}

//extension TouchStroke {
//  static let example = TouchStroke(
//    points: [StrokePoint(position: CGPoint(x: 100, y: 200), timestamp: 5.6, velocity: CGVector(dx: 3, dy: 6))],
//    colour: .orange,
//    rawTouchPoints: [TrackpadTouch(id: 2, position: CGPoint(x: 100, y: 200), timestamp: 5.6, velocity: CGVector(dx: 3, dy: 6), pressure: nil)]
//  )
//}

public enum StrokePointType {
  case pointsFiltered(TouchPoint)
  case pointsOriginal(TouchPoint)
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
