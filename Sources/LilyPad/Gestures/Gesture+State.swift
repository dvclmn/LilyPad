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
    touches: Set<TouchPoint>,
    phase: GesturePhase,
    in rect: CGRect,
  )
  var isActive: Bool { get }
}

struct MappingSpaces {
  var canvas: CGRect
  var viewport: CGRect
}


struct TrackpadGestureState {
  var pan = PanGestureState()
  var zoom = ZoomGestureState()
  var rotation = RotateGestureState()
  
  /// The space to which touch points are mapped (e.g., canvas or viewport)
  var mappingRect: CGRect = .zero
//  var canvasSize: CGSize = .zero
//  var viewportSize: CGSize = .zero
  
  mutating func update(
    touches: Set<TouchPoint>,
    phase: GesturePhase,
    in rect: CGRect,
  ) {
    pan.update(
      touches: touches,
      phase: phase,
      in: rect,
    )
    zoom.update(
      touches: touches,
      phase: phase,
      in: rect,
    )
    rotation.update(
      touches: touches,
      phase: phase,
      in: rect,
    )
  }
}

//
//struct ZoomGestureState {
//  var scale: CGFloat
//  var startDistance: CGFloat
//}
//
//struct RotationGestureState {
//  var angle: CGFloat
//  var startAngle: CGFloat
//}

//struct TrackpadGestureState {
//  var phase: GesturePhase = .ended
//  var startingTouches: TouchPositions?
//
//  var lastPanOffset: CGPoint = .zero
//  var lastScale: CGFloat = 1.0
//
//
//  var velocity: CGPoint = .zero
//  var lastTimestamp: TimeInterval?
//  var isGestureActive: Bool {
//    phase == .began || phase == .changed
//  }
//}
