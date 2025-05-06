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
  
  /// Skips nearby points during fast movement
  public var minDistance: CGFloat = 20
  
  /// Forces inclusion of points during slow movement
  public var minSpeedForSparseSampling: CGFloat = 1.0
  
  public init() {
    print("`StrokeEngine` created at \(Date.now.format(.timeDetailed))")
  }
  
  public func shouldAddPoint(
    from last: CGPoint,
    to current: CGPoint,
    speed: CGFloat
  ) -> Bool {
    let distance = hypot(current.x - last.x, current.y - last.y)
    let doesNeedPoint: Bool = distance > minDistance || speed < minSpeedForSparseSampling
    
//    print("Assessing if need to add a Point. Distance: \(distance), Speed: \(speed). Need Point?: \(doesNeedPoint)")
    
    return doesNeedPoint
  }
  
}

extension StrokeEngine {
  public func drawStroke(
    _ stroke: TouchStroke,
    in context: GraphicsContext
  ) {
    guard stroke.points.count >= 4 else { return }
    
    var path = Path()
    
    let controlPoints = stroke.points
    for i in 1..<controlPoints.count - 2 {
      let p0 = controlPoints[i - 1]
      let p1 = controlPoints[i]
      let p2 = controlPoints[i + 1]
      let p3 = controlPoints[i + 2]
      
      for j in 0..<splineResolution {
        let t = CGFloat(j) / CGFloat(splineResolution)
        let position = catmullRom(p0.position, p1.position, p2.position, p3.position, t)
        
        let width = interpolatedWidth(p0: p0, p1: p1, p2: p2, p3: p3, t: t)
        
        drawPoint(position, width: width, in: &path)
      }
    }
    
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
  
  func catmullRom(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint, _ t: CGFloat) -> CGPoint {
    let t2 = t * t
    let t3 = t2 * t
    
    let x =
    0.5
    * (2 * p1.x + (p2.x - p0.x) * t + (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2
       + (3 * p1.x - p0.x - 3 * p2.x + p3.x) * t3)
    
    let y =
    0.5
    * (2 * p1.y + (p2.y - p0.y) * t + (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2
       + (3 * p1.y - p0.y - 3 * p2.y + p3.y) * t3)
    
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
      p.width(using: strokeWidthHandler) ?? strokeWidthHandler.calculateStrokeWidth(speed: 0, pressure: 0)
    }
    
    let w0 = width(for: p0)
    let w1 = width(for: p1)
    let w2 = width(for: p2)
    let w3 = width(for: p3)
    
    let t2 = t * t
    let t3 = t2 * t
    
    return 0.5 * (2 * w1 + (w2 - w0) * t + (2 * w0 - 5 * w1 + 4 * w2 - w3) * t2 + (3 * w1 - w0 - 3 * w2 + w3) * t3)
  }
}
