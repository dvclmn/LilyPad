//
//  Model+TouchEvent.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import AppKit

public struct TouchEventData: Sendable, Equatable {
  public let touches: Set<TouchPoint>
  
  public static let atRest = TouchEventData(
    touches: [],
  )
  
  public init(
    touches: Set<TouchPoint>,
  ) {
    self.touches = touches
  }
}
extension TouchEventData: CustomStringConvertible {
  public var description: String {
    """
    
    TouchEventData
      - Touches (count: \(touches.count): 
          \(touches)
    
    
    """
  }
}

