//
//  Model+PointPair.swift
//  LilyPad
//
//  Created by Dave Coleman on 11/5/2025.
//

import BaseHelpers
import SwiftUI

public protocol PointPairable {
  var mappingRect: CGRect { get }
  var pointPair: PointPair { get }
  var midPointBetween: CGPoint { get }
  var distanceBetween: CGFloat { get }
  var angleBetween: Angle { get }
}

extension PointPairable {

  var p1: CGPoint { pointPair.p1 }
  var p2: CGPoint { pointPair.p2 }

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
}

/// I haven't yet worked out if `TouchPair`
/// needs a `mappingRect: CGRect`
public struct TouchPair: PointPairable {
  public let first: TouchPoint
  public let second: TouchPoint
  public let mappingRect: CGRect?

  public init(
    first: TouchPoint,
    second: TouchPoint,
    mappingRect: CGRect?
  ) {
    self.first = first
    self.second = second
    self.mappingRect = mappingRect
  }

  public init?(_ touches: Set<TouchPoint>) {
    let sorted = touches.sorted { $0.timestamp < $1.timestamp }
    guard sorted.count >= 2 else {
      print("Cannot form a TouchPair with fewer than two touches")
      return nil
    }
    self.first = sorted[0]
    self.second = sorted[1]
  }

  /// I think a `TouchPair` shouldn't be initialised from
  /// point-only data. If this is neccessary, a
  /// `PointPair` should be used


}

extension TouchPair {
  
  public var pointPair: PointPair {
    let p1 = first.position.mapped(to: mappingRect)
    let p2 = second.position.mapped(to: mappingRect)
    
    return PointPair(
      mappedP1: p1,
      mappedP2: p2,
      mappingRect: mappingRect
    )
  }
}

/// This is to address the common scenario where we have a set of touches:
/// `Set<TouchPoint>`, and want to know the order in which they were invoked
extension Set where Element == TouchPoint {
  public var touchPair: TouchPair? {
    TouchPair(self)
  }
  //  public var sortedByTimestamp: [TouchPoint] {
  //    self.sorted { $0.timestamp < $1.timestamp }
  //  }
  //
  //  public var touchPair: TouchPair? {
  //    let sorted = self.sortedByTimestamp
  //    guard sorted.count >= 2 else { return nil }
  //
  //    let pair = TouchPair(
  //      first: sorted[0],
  //      second: sorted[1]
  //    )
  //    return pair
  //
  //  }
}

/// Useful for contexts where only positional data is relevant.
/// Prefer ``TouchPair`` if pressure or velocity info is required
///
/// I could be wrong, but maybe `TouchPair` has a concept of
/// first and second points, but `PointPair` doesn't? Not sure.
//public struct PointPair {
//  public let p1: CGPoint
//  public let p2: CGPoint
//  public let mappingRect: CGRect
//
//  public init(
//    mappedP1: CGPoint,
//    mappedP2: CGPoint,
//    mappingRect: CGRect
//  ) {
//    self.p1 = mappedP1
//    self.p2 = mappedP2
//    self.mappingRect = mappingRect
//  }
//}
//
//extension PointPair {
//  static func mapped(
//    from touches: Set<TouchPoint>,
//    to mappingRect: CGRect
//  ) -> PointPair {
//
//    let touchesArray = touches.array
//    precondition(touchesArray.count == 2, "Exactly 2 touches required")
//
//    let p1 = touchesArray[0].position.mapped(to: mappingRect)
//    let p2 = touchesArray[1].position.mapped(to: mappingRect)
//
//    return PointPair(
//      mappedP1: p1,
//      mappedP2: p2,
//      mappingRect: mappingRect
//    )
//  }
//}
