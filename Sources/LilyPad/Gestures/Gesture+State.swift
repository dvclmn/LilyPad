//
//  Gesture+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

protocol GestureTrackable {
  var requiredTouchCount: Int { get }
  mutating func update(
    event: TouchEventData,
    in rect: CGRect,
  )
  var isActive: Bool { get }
}

struct MappingSpaces {
  var canvas: CGRect
  var viewport: CGRect
}

public enum TrackpadGesturePhase: Sendable, Equatable {
  case none
  case began
  case moved
  case ended
  case cancelled
}

struct TrackpadGestureState {
  var pan = PanGestureState()
  var zoom = ZoomGestureState()
  var rotation = RotateGestureState()
//  var drawing = DrawingGestureState()
  
  /// The space to which touch points are mapped (e.g., canvas or viewport)
  var mappingRect: CGRect = .zero

  mutating func update(event: TouchEventData, in rect: CGRect) {
    pan.update(event: event, in: rect)
    zoom.update(event: event, in: rect)
    rotation.update(event: event, in: rect)
//    drawing.update(event: event, in: rect)
  }
}
