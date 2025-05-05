//
//  Models.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import MemberwiseInit
import SwiftUI

//public struct RawTouches: Identifiable, Equatable, Hashable {
//  
//  public typealias ID = TouchStroke.ID
//  public let id: ID
//  public let touches: [TrackpadTouch]
//}

//extension Array where Element == RawTouches {
//  
//  public func getTouchesForID(_ id: TouchStroke.ID) -> [TrackpadTouch] {
//    let rawTouches = self.first { touch in
//      touch.id == id
//    }
//    return rawTouches?.touches ?? []
//  }
//}


/// Represents a touch stroke with a series of points and widths
@MemberwiseInit(.public)
public struct TouchStroke: Identifiable {
  public let id: UUID = UUID()
  public var points: [StrokePoint]
  public var colour: Color

  /// These are the *original* points recieved, before filtering.
  /// Used for debugging only
//  public var rawTouchPoints: [TrackpadTouch] = []

  /// Add a point to the stroke with a specified width
  public mutating func addPoint(
    _ point: StrokePoint,
//    kind: StrokePointType
  ) {
//    switch kind {
//      case .strokePoint(let newPoints):
        points.append(point)

//      case .rawTouchPoint(let newTouches):
//        fatalError("Raw touches no longer supported here")
//        rawTouchPoints.append(newTouches)
//    }
  }

  public var cgPoints: [CGPoint] {
    return points.map(\.position)
  }
  
//  public mutating func clearRawTouches() {
//    rawTouchPoints.removeAll()
//  }

  public subscript(pointAtIndex index: Int) -> CGPoint {
    let result = points[index].position
    return result
  }
}


//public enum StrokePointType {
//  case strokePoint(StrokePoint)
//  case rawTouchPoint(TrackpadTouch)
//}

enum StrokeState {
  case active
  case completed
  case optimized
}

struct StrokeWrapper {
  var stroke: TouchStroke
  var state: StrokeState
}
