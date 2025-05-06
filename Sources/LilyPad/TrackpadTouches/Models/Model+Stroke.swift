//
//  Models.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import MemberwiseInit
import SwiftUI

/// Represents a touch stroke with a series of points and widths
@MemberwiseInit(.public)
public struct TouchStroke: Identifiable {
  public let id: UUID = UUID()
  public var points: [StrokePoint]
  public var colour: Color
  
  /// These are the *original* points recieved, before filtering.
  /// Used for debugging only
  public var rawTouchPoints: [TrackpadTouch] = []

  /// Add a point to the stroke with a specified width
//  public mutating func addPoint(_ point: StrokePoint) {
//    points.append(point)
//  }
  
  public mutating func addPoint(
    kind: StrokePointType
  ) {
    switch kind {
      case .strokePoint(let newPoints):
        points.append(newPoints)
        
      case .rawTouchPoint(let newTouches):
        rawTouchPoints.append(newTouches)
    }
  }

  public var cgPoints: [CGPoint] {
    return points.map(\.position)
  }

  public subscript(pointAtIndex index: Int) -> CGPoint {
    let result = points[index].position
    return result
  }
}

extension TouchStroke {
  static let example = TouchStroke(
    points: [StrokePoint(position: CGPoint(x: 100, y: 200), timestamp: 5.6, velocity: CGVector(dx: 3, dy: 6))],
    colour: .orange,
    rawTouchPoints: [TrackpadTouch(id: 2, position: CGPoint(x: 100, y: 200), timestamp: 5.6, velocity: CGVector(dx: 3, dy: 6), pressureData: nil)]
  )
}

public enum StrokePointType {
  case strokePoint(StrokePoint)
  case rawTouchPoint(TrackpadTouch)
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
