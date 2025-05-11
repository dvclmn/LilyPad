//
//  Handler+TouchPositions.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation
import BaseHelpers

/// Used in `GestureStateHandler` to define gesture start positions
//struct TouchPositions: Sendable, Equatable, Hashable {
//  var p1: CGPoint
//  var p2: CGPoint
//  
//  var mappingRect: CGRect
//  
//  
//  
//  
//  var midPoint: CGPoint {
//    CGPoint.midPoint(from: p1, to: p2)
//  }
//  
//  var distanceBetween: CGFloat {
//    return p1.distance(to: p2)
//  }
//
//  /// Angle in radians, from p1 to p2, in range [-π, π]
//  var angleBetween: CGFloat {
//    CGPoint.angleBetween(p1, p2)
//  }
//
//}
//
//extension TouchPositions: CustomStringConvertible {
//  public var description: String {
//    """
//    TouchPositions
//      - p1: \(p1.displayString)
//      - p2: \(p2.displayString)
//      - Mapping rect: \(mappingRect)
//      - Mid point: \(midPoint.displayString)
//      - Angle: \(angleBetween.displayString)
//      - Distance: \(distanceBetween.displayString)
//    """
//  }
//}
