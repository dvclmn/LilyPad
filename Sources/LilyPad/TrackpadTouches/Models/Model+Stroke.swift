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
  
  /// This should be *all* points that come from AppKit
  public var points: [TouchPoint] = []
  public var colour: Swatch
  
  /// These are the *original* points recieved, before filtering.

  /// Add a point to the stroke with a specified width
//  public mutating func addPoint(_ point: StrokePoint) {
//    points.append(point)
//  }
  
  public mutating func addPoint(_ point: TouchPoint) {
    points.append(point)
  }

  public var cgPoints: [CGPoint] {
    return points.map(\.position)
  }

//  public subscript(pointAtIndex index: Int) -> CGPoint {
//    let result = points[index].position
//    return result
//  }
}

extension TouchStroke {
  
  public func filteredPoints(
    using config: PointConfig,
    engine: StrokeEngine
  ) -> [TouchPoint] {
    engine.filterPoints(from: points, pointConfig: config)
  }
}


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
