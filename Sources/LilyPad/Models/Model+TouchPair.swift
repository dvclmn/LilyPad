//
//  Model+PointPair.swift
//  LilyPad
//
//  Created by Dave Coleman on 11/5/2025.
//

import BaseHelpers
import SwiftUI

public struct TouchPair: Sendable, Hashable {
  public let first: MappedTouchPoint
  public let second: MappedTouchPoint

  public init(
    first: MappedTouchPoint,
    second: MappedTouchPoint,
  ) {
    self.first = first
    self.second = second
  }

  public init?(
    _ touches: [MappedTouchPoint],
    referencePair: TouchPair?
  ) {
    
    guard touches.count == 2 else { return nil }
    
    guard let referencePair else {
      self = Self.timestampSortedTouches(touches)
      return
    }
    
    let lookup = Dictionary(uniqueKeysWithValues: touches.map { ($0.id, $0) })
    
    guard let first = lookup[referencePair.first.id],
          let second = lookup[referencePair.second.id] else {
      self = Self.timestampSortedTouches(touches)
      return
    }
    
    self.first = first
    self.second = second
  }
}

extension TouchPair {
  
  public var idsForComparison: String {
    let maxLength: Int = 6
    let firstID = first.id.string.suffix(maxLength)
    let secondID = second.id.string.suffix(maxLength)
    let result = "First ID: ...\(firstID), Second ID: ...\(secondID)"
    return result
  }
  
  private static func timestampSortedTouches(
    _ touches: [MappedTouchPoint],
  ) -> TouchPair {
    let sorted = touches.sorted { $0.timestamp < $1.timestamp }
    return TouchPair(first: sorted[0], second: sorted[1])
  }

  //  func makeStablePair(
  //    from touches: [MappedTouchPoint],
  //    using referencePair: TouchPair?
  //  ) -> TouchPair {
  //    if let referencePair {
  //      /// Find same IDs and preserve their original ordering
  //      let lookup = Dictionary(uniqueKeysWithValues: touches.map { ($0.id, $0) })
  //      if let first = lookup[referencePair.first.id],
  //         let second = lookup[referencePair.second.id] {
  //        return TouchPair(first: first, second: second)
  //      }
  //    }
  //
  //    // Fallback: just sort by ID (or x/y position if you prefer)
  //    let sorted = touches.sorted { $0.id < $1.id }
  //    return TouchPair(first: sorted[0], second: sorted[1])
  //  }

  public func hasSameTouchIDs(as other: TouchPair) -> Bool {
    let selfIDs = Set([first.id, second.id])
    let otherIDs = Set([other.first.id, other.second.id])
    return selfIDs == otherIDs
  }

  var p1: CGPoint {
    first.position
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
  
  func distance(to other: TouchPair) -> CGFloat {
    self.midPointBetween.distance(to: other.midPointBetween)
//    self.midpoint.distance(to: other.midpoint)
  }

}

extension TouchPair: CustomStringConvertible {
  public var description: String {
    let firstDesc = TouchPoint.generateDescription(for: self.first)
    let secondDesc = TouchPoint.generateDescription(for: self.second)
    return """
    
    
    First Point: \(firstDesc)
    
    Second Point: \(secondDesc)
    
    
    """
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
