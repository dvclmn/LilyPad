//
//  Model+Gesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

protocol GestureTrackable: Sendable, Equatable, Hashable {
  
  associatedtype GestureValue
  var value: GestureValue { get set }
  var startTouchPositions: TouchPositions? { get set }
  var lastValue: GestureValue { get set }
  
  //  var requiredTouchCount: Int { get }
  //  var isActive: Bool { get }
  
  mutating func update(
    event: TouchEventData,
    in rect: CGRect,
  )
}

public enum GestureType: Sendable {
  case draw
  case pan
  case zoom
  case rotate
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

