//
//  Handler+Zoom.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI
import BaseHelpers

@Observable
final class ZoomHandler {
  var touches: Set<TouchPoint> = []
  
  var scale: CGFloat = 1
  var offset: CGPoint = .zero
  var canvasSize: CGSize = .zero
  
  var viewportSize: CGSize = .zero
  
}

extension ZoomHandler {
  
  var canvasPosition: CGPoint {

    let viewportMidPoint = viewportSize.midpoint
//    let canvasMidPoint = canvasSize.midpoint
    
    let centred = viewportMidPoint
    return offset + centred
  }
}

struct TouchPositions {
  var p1: CGPoint
  var p2: CGPoint
  
  var destinationRect: CGRect
  
  init(p1: CGPoint, p2: CGPoint, destinationRect: CGRect) {
    
    let p1Mapped: CGPoint = p1.mapped(to: destinationRect)
    let p2Mapped: CGPoint = p2.mapped(to: destinationRect)
    
    self.p1 = p1Mapped
    self.p2 = p2Mapped
    self.destinationRect = destinationRect
  }
  
  init(touches: Set<TouchPoint>, destinationRect: CGRect) {
    let touchesArray = Array(touches)
    
    let touch01 = touchesArray[0]
    let touch02 = touchesArray[1]
    
    let p1Mapped: CGPoint = touch01.position.mapped(to: destinationRect)
    let p2Mapped: CGPoint = touch02.position.mapped(to: destinationRect)

    self.init(p1: p1Mapped, p2: p2Mapped, destinationRect: destinationRect)
  }
  var midPoint: CGPoint {
    CGPoint.midPoint(p1: p1, p2: p2)
  }
  
  var distanceBetween: CGFloat {
    hypot(p2.x - p1.x, p2.y - p1.y)
  }
  
  /// Using atan2(sin, cos) for Delta
  /// Keeps delta angle within a canonical range of [-π, π], so you can handle
  /// wraparounds properly (e.g., going from +179° to -179° yields ~2°, not ~-358°).
  ///
  /// Note below Rotation Threshold Logic, somewhere in your gesture handling logic,
  /// where `rotationThreshold` might be, say,
  /// `let rotationThreshold: CGFloat = .pi / 36 // 5 degrees`
  ///
  /// ```
  /// if let start = firstPosition, let current = currentPosition {
  ///   let angleDelta = current.angleDelta(from: start)
  ///
  ///   if abs(angleDelta) > rotationThreshold {
  ///     // Begin rotation gesture!
  ///     store.rotation = angleDelta
  ///   } else {
  ///     store.rotation = 0 // Still in deadzone
  ///   }
  /// }
  /// ```
  /// Then, for SwiftUI
  /// `content.rotationEffect(.radians(store.rotation))`
  ///
  /// Angle in radians, from p1 to p2, in range [-π, π]
  var angle: CGFloat {
    atan2(p2.y - p1.y, p2.x - p1.x)
  }
  
  /// Returns delta angle from another `TouchPositions`, normalized to [-π, π]
  func angleDelta(from other: TouchPositions) -> CGFloat {
    let delta = angle - other.angle
    return atan2(sin(delta), cos(delta)) // Normalize
  }
}
