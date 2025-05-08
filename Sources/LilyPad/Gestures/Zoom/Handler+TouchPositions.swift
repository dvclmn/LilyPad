//
//  Handler+TouchPositions.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

struct TouchPositions: Sendable, Equatable, Hashable {
  var p1: CGPoint
  var p2: CGPoint
  
  var mappingRect: CGRect
  
  init(mappedP1: CGPoint, mappedP2: CGPoint, mappingRect: CGRect) {
    self.p1 = mappedP1
    self.p2 = mappedP2
    self.mappingRect = mappingRect
  }
  
  static func mapped(from touches: Set<TouchPoint>, to mappingRect: CGRect) -> TouchPositions {
    
//    let positions: String = touches.reduce("", { partialResult, point in
//      partialResult + point.position.displayString
//    })
//    print("Mapping \(touches.count) touches with positions \(positions) to \(mappingRect)")
    let touchesArray = Array(touches)
    precondition(touchesArray.count == 2, "Exactly 2 touches required")
    
    let p1 = touchesArray[0].position.mapped(to: mappingRect)
    let p2 = touchesArray[1].position.mapped(to: mappingRect)
    
    return TouchPositions(
      mappedP1: p1,
      mappedP2: p2,
      mappingRect: mappingRect
    )
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

extension TouchPositions: CustomStringConvertible {
  public var description: String {
    """
    TouchPositions
      - p1: \(p1.displayString)
      - p2: \(p2.displayString)
      - Mapping rect: \(mappingRect)
      - Mid point: \(midPoint.displayString)
      - Angle: \(angle.displayString)
      - Distance: \(distanceBetween.displayString)
    """
  }
}
