//
//  Model+PointPair.swift
//  LilyPad
//
//  Created by Dave Coleman on 11/5/2025.
//

import BaseHelpers
import SwiftUI

/// I haven't yet worked out if `TouchPair`
/// needs a `mappingRect: CGRect`
public struct TouchPair {
  public let first: MappedTouchPoint
  public let second: MappedTouchPoint
//  public let mappingRect: CGRect

  public init(
    first: MappedTouchPoint,
    second: MappedTouchPoint,
//    mappingRect: CGRect
  ) {
    self.first = first
    self.second = second
//    self.mappingRect = mappingRect
  }

//  public init?(
//    _ touches: Set<TouchPoint>,
//    mappingRect: CGRect
//  ) {
//    let sorted = touches.sorted { $0.timestamp < $1.timestamp }
//    guard sorted.count >= 2 else {
////      print("Cannot form a TouchPair with fewer than two touches")
//      return nil
//    }
//    self.first = sorted[0]
//    self.second = sorted[1]
//    self.mappingRect = mappingRect
//  }
  
  public init?(
    _ touches: [MappedTouchPoint],
//    mappingRect: CGRect
  ) {
//    let sorted = touches.sorted { $0.timestamp < $1.timestamp }
    guard touches.count == 2 else {
      //      print("Cannot form a TouchPair with fewer than two touches")
      return nil
    }
    self.first = touches[0]
    self.second = touches[1]
//    self.mappingRect = mappingRect
  }

}

extension TouchPair {
  
  public func hasSameTouchIDs(as other: TouchPair) -> Bool {
    let selfIDs = Set([first.id, second.id])
    let otherIDs = Set([other.first.id, other.second.id])
    return selfIDs == otherIDs
  }

  var p1: CGPoint {
    first.position
//    first.position.mapped(to: mappingRect)
  }
  
  var p2: CGPoint {
    second.position
  }
  
  public var midPointBetween: CGPoint {
    return CGPoint.midPoint(from: p1, to: p1)
  }
  public var distanceBetween: CGFloat {
    return p1.distance(to: p2)
  }
  /// Angle in radians, from p1 to p2, in range [-π, π]
  public var angleBetween: Angle {
    CGPoint.angle(from: p1, to: p2)
  }
  
  public var angleInRadiansBetween: CGFloat {
    CGPoint.angleInRadians(from: p1, to: p2)
  }
  
}

/// This is to address the common scenario where we have a set of touches:
/// `Set<TouchPoint>`, and want to know the order in which they were invoked
//extension Set where Element == TouchPoint {
//  public func touchPair(in rect: CGRect) -> TouchPair? {
//    TouchPair(self, mappingRect: rect)
//  }
//  
//}
