//
//  Gesture+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

protocol GestureTrackable {
  mutating func update(touches: TouchPositions, phase: GesturePhase)
  var isActive: Bool { get }
}


struct TrackpadGestureState {
  var pan = PanGestureState()
  var zoom = ZoomGestureState()
  var rotation = RotationGestureState()
  
  mutating func update(touches: TouchPositions, phase: GesturePhase) {
    pan.update(touches: touches, phase: phase)
    zoom.update(touches: touches, phase: phase)
    rotation.update(touches: touches, phase: phase)
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
