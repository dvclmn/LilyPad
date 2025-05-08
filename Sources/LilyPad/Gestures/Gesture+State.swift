//
//  Gesture+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

protocol GestureTrackable: Sendable, Equatable, Hashable {
  associatedtype GestureValue
  var requiredTouchCount: Int { get }
  var defaultValue: GestureValue { get }
  var isActive: Bool { get }
  
  mutating func update(
    event: TouchEventData,
    in rect: CGRect,
  )
}



struct MappingSpaces {
  var canvas: CGRect
  var viewport: CGRect
}

public enum TrackpadGesturePhase: String, Sendable, Equatable {
  case none
  case began
  case moved
  case ended
  case cancelled
}

//struct TrackpadGestureState: Equatable {
//  
////  var drawing = DrawingGestureState()
//  
//  /// The space to which touch points are mapped (e.g., canvas or viewport)
//  var mappingRect: CGRect = .zero
//
// 
//}
