//
//  Model+StrokeEngine.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import SwiftUI

public struct StrokeEngine {

  public var strokeWidthHandler = StrokeWidthHandler()
  public var splineResolution: Int = 8
  public var minDistance: CGFloat = 20
  public var minSpeedForSparseSampling: CGFloat = 1.0
  public var splineTension: CGFloat = 0.0 // Added from CatmullRom

  public init() {
    print("`StrokeEngine` created at \(Date.now.format(.timeDetailed))")
  }

  public func shouldAddPoint(
    from last: CGPoint,
    to current: CGPoint,
    speed: CGFloat
  ) -> Bool {
    let distance = hypot(current.x - last.x, current.y - last.y)
    return distance > minDistance || speed < minSpeedForSparseSampling
  }

}

extension StrokeEngine {
  public func drawStroke(
    _ stroke: TouchStroke,
    isClosed: Bool = false,
    in context: GraphicsContext
  ) {
    let points = stroke.points
    guard points.count >= 2 else { return }
    
    var path = Path()
    
    /// Handle special cases based on point count
    if points.count < 4 && !isClosed {
      // Draw simple lines for few points
      if let first = points.first {
        path.move(to: first.position)
        for i in 1..<points.count {
          let position = points[i].position
          let width = points[i].width(using: strokeWidthHandler) ??
          strokeWidthHandler.calculateStrokeWidth(for: 0)
          drawPoint(position, width: width, in: &path)
        }
      }
      context.stroke(path, with: .color(.black), lineWidth: 1)
      return
    }
    
    // Create working array for closed paths if needed
    var workingPoints = points
    if isClosed && points.count >= 3 {
      workingPoints.append(points[0])
      workingPoints.insert(points[points.count - 1], at: 0)
    }
    
    // Start and end indices for the spline calculation
    let startIndex = isClosed ? 1 : 0
    let endIndex = isClosed ? workingPoints.count - 2 : workingPoints.count - 3
    
    for i in startIndex...endIndex {
      let p0 = workingPoints[max(0, i - 1)]
      let p1 = workingPoints[i]
      let p2 = workingPoints[min(workingPoints.count - 1, i + 1)]
      let p3 = workingPoints[min(workingPoints.count - 1, i + 2)]
      
      for j in 0..<splineResolution {
        let t = CGFloat(j) / CGFloat(splineResolution)
        let position = catmullRom(p0.position, p1.position, p2.position, p3.position, t)
        let width = interpolatedWidth(p0: p0, p1: p1, p2: p2, p3: p3, t: t)
        drawPoint(position, width: width, in: &path)
      }
    }
    
    if isClosed {
      path.closeSubpath()
    }
    #warning("This is where I could play with 'brush' style")
    context.stroke(path, with: .color(.black), lineWidth: 1)
  }

  func drawPoint(_ position: CGPoint, width: CGFloat, in path: inout Path) {
    let rect = CGRect(
      x: position.x - width / 2,
      y: position.y - width / 2,
      width: width,
      height: width
    )
    path.addEllipse(in: rect)
  }
  

  func catmullRom(
    _ p0: CGPoint,
    _ p1: CGPoint,
    _ p2: CGPoint,
    _ p3: CGPoint,
    _ t: CGFloat
  ) -> CGPoint {
    // Apply tension parameter from CatmullRom struct
    let alpha = (1.0 - splineTension) / 2.0
    
    let t2 = t * t
    let t3 = t2 * t
    
    let x = 0.5 * (
      2 * p1.x +
      (p2.x - p0.x) * t * alpha +
      (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2 +
      (3 * p1.x - p0.x - 3 * p2.x + p3.x) * t3
    )
    
    let y = 0.5 * (
      2 * p1.y +
      (p2.y - p0.y) * t * alpha +
      (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2 +
      (3 * p1.y - p0.y - 3 * p2.y + p3.y) * t3
    )
    
    return CGPoint(x: x, y: y)
  }
  
  func interpolatedWidth(
    p0: StrokePoint,
    p1: StrokePoint,
    p2: StrokePoint,
    p3: StrokePoint,
    t: CGFloat
  ) -> CGFloat {
    func width(for p: StrokePoint) -> CGFloat {
      p.width(using: strokeWidthHandler) ?? strokeWidthHandler.calculateStrokeWidth(for: 0)
    }
    
    let w0 = width(for: p0)
    let w1 = width(for: p1)
    let w2 = width(for: p2)
    let w3 = width(for: p3)
    
    let t2 = t * t
    let t3 = t2 * t
    
    return 0.5 * (
      2 * w1 +
      (w2 - w0) * t +
      (2 * w0 - 5 * w1 + 4 * w2 - w3) * t2 +
      (3 * w1 - w0 - 3 * w2 + w3) * t3
    )
  }
}
