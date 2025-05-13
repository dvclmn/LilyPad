//
//  Model+TouchEvent.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import AppKit

public struct TouchEventData: Sendable, Equatable {
  public let touches: Set<TouchPoint>
//  public let phase: TrackpadGesturePhase
  
  public static let atRest = TouchEventData(
    touches: [],
//    phase: .none,
  )
  
  public init(
    touches: Set<TouchPoint>,
//    phase: TrackpadGesturePhase
  ) {
    self.touches = touches
//    self.phase = phase
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
//
//public struct GestureEventData: Sendable, Equatable {
////  public let touches: Set<TouchPoint>
//  public let gesture: String
////  public let phase: TrackpadGesturePhase
//  
//  public static let atRest = GestureEventData(
//    gesture: "resting",
////    phase: .none,
//  )
//  
//  public init(
//    gesture: String,
////    phase: TrackpadGesturePhase
//  ) {
//    self.gesture = gesture
////    self.phase = phase
//  }
//}
//extension TouchEventData: CustomStringConvertible {
//  public var description: String {
//    """
//    
//    TouchEventData
//      - Touches (count: \(touches.count): 
//    
//          \(touches)
//    
//    
//      - Phase: \(phase.rawValue)
//    
//    """
//  }
//}

