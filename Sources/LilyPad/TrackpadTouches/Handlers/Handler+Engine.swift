//
//  Model+StrokeEngine.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import BaseHelpers
import SwiftUI

public struct StrokeEngine {

  public var strokeWidthHandler = StrokeWidthHandler()

  public init() {
    print("`StrokeEngine` created at \(Date.now.format(.timeDetailed))")
  }

  public func filterPoints(
    from rawPoints: [TouchPoint],
    config: StrokeConfiguration
  ) -> [TouchPoint] {

    guard rawPoints.count > 1,
      let firstPoint = rawPoints.first
    else {
      return rawPoints
    }
    var filtered: [TouchPoint] = [firstPoint]
    for i in 1..<rawPoints.count {
      guard let lastPoint = filtered.last else { continue }
      let lastPosition = lastPoint.position
      let current = rawPoints[i]
      if shouldAddPoint(from: lastPosition, to: current, config: config) {
        filtered.append(current)
      }
    }
    return filtered
  }


  /// Determines whether to add a new point to the stroke
  /// - Parameters:
  ///   - last: The previous point in the stroke
  ///   - current: The new touch event
  /// - Returns: true if the point should be added to the stroke
  private func shouldAddPoint(
    from last: CGPoint,
    to current: TouchPoint,
    config: StrokeConfiguration
  ) -> Bool {

    let distance = hypot(current.position.x - last.x, current.position.y - last.y)

    /// Always add point if we exceed distance threshold
    guard distance < config.minDistance else { return true }

    /// Use the touch event's pre-calculated velocity
    let speed = current.velocity.speed

    /// Add point if moving slowly
    return speed < config.minSpeedForDenseSampling
  }

}

extension StrokeEngine {
  
  public func drawStroke(
    _ stroke: TouchStroke,
    config: StrokeConfiguration,
    isShowingPoints: Bool = false,
    in context: GraphicsContext
  ) {
    
    let filteredPoints = filterPoints(
      from: stroke.points,
      config: config
    )

    guard filteredPoints.count >= 4 else { return }

    var leftEdge: [CGPoint] = []
    var rightEdge: [CGPoint] = []

    var previousPos: CGPoint?
    var pointIndicatorPath = Path()
    for i in 1..<filteredPoints.count - 2 {
      let p0 = filteredPoints[i - 1]
      let p1 = filteredPoints[i]
      let p2 = filteredPoints[i + 1]
      let p3 = filteredPoints[i + 2]

      for j in 0..<config.pointDensity {
        let t = CGFloat(j) / CGFloat(config.pointDensity)
        
        let pos = catmullRom(
          p0.position,
          p1.position,
          p2.position,
          p3.position,
          t,
          type: config.curveType
        )
        
        
//        let pos = catmullRom(p0.position, p1.position, p2.position, p3.position, t)
        let width = interpolatedWidth(p0: p0, p1: p1, p2: p2, p3: p3, t: t, config: config)

        if isShowingPoints {
          drawPoint(pos, width: width, in: &pointIndicatorPath)
        }
        
        if let prev = previousPos {
          let dir = CGPoint(x: pos.x - prev.x, y: pos.y - prev.y)
          let normal = CGPoint(x: -dir.y, y: dir.x).normalised
          let offset = normal * (width / 2)

          leftEdge.append(pos + offset)
          rightEdge.append(pos - offset)
        }

        previousPos = pos
      }
      context.fill(pointIndicatorPath, with: .color(.purple))
    }

    /// Build closed path from left edge forward, right edge backward
    var path = Path()
    guard let first = leftEdge.first else { return }
    path.move(to: first)

    for pt in leftEdge.dropFirst() {
      path.addLine(to: pt)
    }
    for pt in rightEdge.reversed() {
      path.addLine(to: pt)
    }
    path.closeSubpath()

    context.fill(path, with: .color(.black))

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

//  func catmullRom(
//    _ p0: CGPoint,
//    _ p1: CGPoint,
//    _ p2: CGPoint,
//    _ p3: CGPoint,
//    _ t: CGFloat
//  ) -> CGPoint {
//    let t2 = t * t
//    let t3 = t2 * t
//
//    let x =
//      0.5
//      * (2 * p1.x + (p2.x - p0.x) * t + (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2
//        + (3 * p1.x - p0.x - 3 * p2.x + p3.x) * t3)
//
//    let y =
//      0.5
//      * (2 * p1.y + (p2.y - p0.y) * t + (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2
//        + (3 * p1.y - p0.y - 3 * p2.y + p3.y) * t3)
//
//    return CGPoint(x: x, y: y)
//  }

  func interpolatedWidth(
    p0: TouchPoint,
    p1: TouchPoint,
    p2: TouchPoint,
    p3: TouchPoint,
    t: CGFloat,
    config: StrokeConfiguration,
  ) -> CGFloat {
    func width(for point: TouchPoint) -> CGFloat {
      point.width(
        using: strokeWidthHandler,
        config: config
      )
    }

    let w0 = width(for: p0)
    let w1 = width(for: p1)
    let w2 = width(for: p2)
    let w3 = width(for: p3)

    let t2 = t * t
    let t3 = t2 * t

    return 0.5 * (2 * w1 + (w2 - w0) * t + (2 * w0 - 5 * w1 + 4 * w2 - w3) * t2 + (3 * w1 - w0 - 3 * w2 + w3) * t3)
  }
  
  func catmullRom(
    _ p0: CGPoint,
    _ p1: CGPoint,
    _ p2: CGPoint,
    _ p3: CGPoint,
    _ t: CGFloat,
    type: CatmullRomType = .uniform
  ) -> CGPoint {
    let alpha: CGFloat
    switch type {
      case .uniform: alpha = 0.0
      case .chordal: alpha = 1.0
      case .centripetal: alpha = 0.5
    }
    
    func tj(_ ti: CGFloat, _ pi: CGPoint, _ pj: CGPoint) -> CGFloat {
      let dx = pj.x - pi.x
      let dy = pj.y - pi.y
      return pow(dx * dx + dy * dy, alpha * 0.5) + ti
    }
    
    let t0: CGFloat = 0
    let t1 = tj(t0, p0, p1)
    let t2 = tj(t1, p1, p2)
    let t3 = tj(t2, p2, p3)
    
    /// Map t in [0, 1] to τ in [t1, t2]
    let tau = t1 + (t2 - t1) * t
    
    /// Perform the recursive interpolation (De Casteljau-like)
    let A1 = interpolate(p0, p1, (tau - t0) / (t1 - t0))
    let A2 = interpolate(p1, p2, (tau - t1) / (t2 - t1))
    let A3 = interpolate(p2, p3, (tau - t2) / (t3 - t2))
    
    let B1 = interpolate(A1, A2, (tau - t1) / (t2 - t1))
    let B2 = interpolate(A2, A3, (tau - t2) / (t3 - t2))
    
    return interpolate(B1, B2, (tau - t2) / (t3 - t2))
  }
  
  func interpolate(_ p0: CGPoint, _ p1: CGPoint, _ t: CGFloat) -> CGPoint {
    CGPoint(
      x: p0.x + (p1.x - p0.x) * t,
      y: p0.y + (p1.y - p0.y) * t
    )
  }
}

public enum CatmullRomType: String, Codable, Hashable {
  case uniform
  case chordal
  case centripetal
}

