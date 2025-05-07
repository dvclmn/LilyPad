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
  var p01A: CGPoint
  var p02B: CGPoint
  
  init(p01A: CGPoint, p02B: CGPoint) {
    self.p01A = p01A
    self.p02B = p02B
  }
  
  init(touches: Set<TouchPoint>) {
    let touchesArray = Array(touches)
    
    let touch01 = touchesArray[0]
    let touch02 = touchesArray[1]
    
    let p1 = touch01.position
    let p2 = touch02.position
    
    self.init(p01A: p1, p02B: p2)
    
  }
  
  var mid: CGPoint {
    CGPoint.midPoint(p1: p01A, p2: p02B)
  }
  
  var distance: CGFloat {
    hypot(p02B.x - p01A.x, p02B.y - p01A.y)
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
  /// Angle in radians, from p01A to p02B, in range [-π, π]
  var angle: CGFloat {
    atan2(p02B.y - p01A.y, p02B.x - p01A.x)
  }
  
  /// Returns delta angle from another `TouchPositions`, normalized to [-π, π]
  func angleDelta(from other: TouchPositions) -> CGFloat {
    let delta = angle - other.angle
    return atan2(sin(delta), cos(delta)) // Normalize
  }
}
