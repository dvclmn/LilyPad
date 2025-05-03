//
//  AppHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI


@Observable
public final class TouchHandler {
  var touches: Set<TrackpadTouch> = []
  
  /// Active strokes being drawn, keyed by touch ID
  private var activeStrokes: [Int: TouchStroke] = [:]
  
  /// Completed strokes
  private var completedStrokes: [TouchStroke] = TouchStroke.exampleStrokes
  
  /// Minimum number of points required to create a smooth curve
  private let minPointsForCurve = 3
  
  
//  var strokeBuilder = StrokePathBuilder()
  
  public var allStrokes: [TouchStroke] {
    return Array(activeStrokes.values) + completedStrokes
  }
  
  public func clearStrokes() {
    activeStrokes.removeAll()
    completedStrokes.removeAll()
  }
  
  public init() {}

  // MARK: - Touches
  
  var windowSize: CGSize = .zero
  var isPointerLocked: Bool = false
  
  var isClicked: Bool = false
  
  let trackPadAspectRatio: CGFloat = 10.0 / 16.0
  
  var trackPadSize: CGSize {
    let trackPadWidth: CGFloat = 700
    let trackPadHeight: CGFloat = trackPadWidth * trackPadAspectRatio
    
    return CGSize(
      width: trackPadWidth,
      height: trackPadHeight
    )
  }
  
  func touchPosition(
    _ touch: TrackpadTouch
  ) -> CGPoint {
    let originX = (windowSize.width - trackPadSize.width) / 2
    let originY = (windowSize.height - trackPadSize.height) / 2
    
    let x = originX + (touch.position.x * trackPadSize.width)
    let y = originY + (touch.position.y * trackPadSize.height)
    
    return CGPoint(x: x, y: y)
  }
  
  
  var isInTouchMode: Bool {
    !isClicked && isPointerLocked
  }
  
  /// Process touch updates and update strokes
  public func processTouches() {
    
    print("Processing touches. Touch count: \(touches.count)")
    // Process each touch to update strokes
    for touch in touches {
      let touchId = touch.id

      /// Update or create stroke for this touch
      if var stroke = activeStrokes[touchId] {
        print("There are active strokes for touch \(touchId). Count: \(stroke.points.count)")
        
        print("Point count for stroke BEFORE: \(stroke.points.count)")
        
        stroke.points.append(touch.position)
        activeStrokes[touchId] = stroke
        
        print("Point count for stroke AFTER: \(stroke.points.count)")
        
        print("`activeStrokes[touchId]`: \(String(describing: activeStrokes[touchId]?.points.count))")
        print("`stroke.points.count`: \(String(describing: stroke.points.count))")
        
      } else {
        /// New touch, create a new stroke
        print("Creating a new stroke for touch \(touchId)")
        
        let stroke = TouchStroke(points: [touch.position], color: .purple)
        activeStrokes[touchId] = stroke
      }
    }
    
    /// Check for ended touches
    let currentIds = Set(touches.map { $0.id })
    let activeIds = Set(activeStrokes.keys)
    let endedIds = activeIds.subtracting(currentIds)
    
    /// Finalize ended strokes
    for touchId in endedIds {
      if let stroke = activeStrokes[touchId], stroke.points.count >= minPointsForCurve {
        print("Adding a stroke to completed strokes. Completed Count: \(completedStrokes.count)")
        completedStrokes.append(stroke)
      }
      activeStrokes.removeValue(forKey: touchId)
    }
  }
  
  // MARK: - Strokes
  
  /// Generate a smooth path for a stroke using Catmull-Rom spline
  public func smoothPath(for stroke: TouchStroke) -> Path {
    guard stroke.points.count >= 2 else {
      // Not enough points for a path
      print("Not enough points. Point count: \(stroke.points.count)")
      return Path()
    }
    
    print("There are enough points. Point count: \(stroke.points.count)")
    
    if stroke.points.count == 2 {
      
      print("Point count is exactly 2. Creating a line.")
      // Just a line for two points
      var path = Path()
      path.move(to: stroke.points[0])
      path.addLine(to: stroke.points[1])
      
      print("Line created between \(stroke.points[0]) and \(stroke.points[1])")
      return path
    }
    
    return catmullRomPath(for: stroke.points)
  }
  
  /// Create a Catmull-Rom spline path from points
  private func catmullRomPath(for points: [CGPoint]) -> Path {
    print("Creating Catmull-Rom spline path...")
    var path = Path()
    
    print("Starting at first point \(points[0])...")
    /// Start at first point
    path.move(to: points[0])
    
    /// Need at least 4 points for Catmull-Rom
    if points.count >= 4 {
      print("We do have 4 or more points. Adding curves...")
      for i in 1..<points.count - 2 {
        let p0 = i > 0 ? points[i-1] : points[i]
        let p1 = points[i]
        let p2 = points[i+1]
        let p3 = i < points.count - 2 ? points[i+2] : points[i+1]
        
        /// Add cubic curve using Catmull-Rom control points
        let controlPoint1 = CGPoint(
          x: p1.x + (p2.x - p0.x) / 6,
          y: p1.y + (p2.y - p0.y) / 6
        )
        
        let controlPoint2 = CGPoint(
          x: p2.x - (p3.x - p1.x) / 6,
          y: p2.y - (p3.y - p1.y) / 6
        )
        
        path.addCurve(to: p2, control1: controlPoint1, control2: controlPoint2)
      }
    } else {
      print("Only have 3 or fewer points. Adding lines...")
      // Fallback for fewer points
      for i in 1..<points.count {
        path.addLine(to: points[i])
      }
    }
    print("Catmull process complete.")
    return path
  }
}

