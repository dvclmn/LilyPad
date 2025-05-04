//
//  SmoothStrokePath.swift
//  LilyPad
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI
import BaseHelpers

public struct StrokePath {
  /// Generate a smooth path for a stroke using Catmull-Rom spline
  public static func smoothPath(for stroke: TouchStroke) -> Path {
    
    /// Check there are enough points to actually create a Path
    guard stroke.points.count >= 2 else {
      return Path()
    }
    /// If there are exactly 2 points, we don't need a curve, just a line
    if stroke.points.count == 2 {
      print("Point count is exactly 2. Creating a line.")
      var path = Path()
      path.move(to: stroke.points[0])
      path.addLine(to: stroke.points[1])
      print("Line created between \(stroke.points[0]) and \(stroke.points[1])")
      return path
    }
    
    return CatmullRom.catmullRomPath(for: stroke.points)
  }
  
  public static func smoothPoints(for stroke: TouchStroke) -> [CGPoint] {
    
    /// Check there are enough points to actually create a Path
    guard stroke.points.count >= 2 else {
      return stroke.points
    }
    /// If there are exactly 2 points, we don't need a curve, just a line
    if stroke.points.count == 2 {
      return stroke.points
    }
    
    return CatmullRom.interpolatedPoints(for: stroke.points)
  }
  
}
