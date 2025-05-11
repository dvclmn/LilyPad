//
//  Model+PointPair.swift
//  LilyPad
//
//  Created by Dave Coleman on 11/5/2025.
//

import Foundation

public struct TouchPair {
  let first: TouchPoint
  let second: TouchPoint
  
  public init(first: TouchPoint, second: TouchPoint) {
    
    self.first = first
    self.second = second
  }
  
  func pointPair(in rect: CGRect) -> PointPair {
    let p1 = first.position.mapped(to: rect)
    let p2 = second.position.mapped(to: rect)
    
    return PointPair(first: p1, second: p2)
  }
}

extension Set where Element == TouchPoint {
  
  public var sortedByTimestamp: [TouchPoint] {
    self.sorted { $0.timestamp < $1.timestamp }
  }
  
  public var touchPair: TouchPair? {
    let sorted = self.sortedByTimestamp
    guard sorted.count >= 2 else { return nil }
    
    let pair = TouchPair(first: sorted[0], second: sorted[1])
    return pair
    
  }
}

public struct PointPair {
  public let first: CGPoint
  public let second: CGPoint
}
