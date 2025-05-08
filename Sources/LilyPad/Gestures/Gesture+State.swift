//
//  Gesture+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

struct TrackpadGestureState {
  var phase: GesturePhase = .ended
  var startingTouches: TouchPositions?
  
  var lastPanOffset: CGPoint = .zero
  var lastScale: CGFloat = 1.0
  
  
  var velocity: CGPoint = .zero
  var lastTimestamp: TimeInterval?
  var isGestureActive: Bool {
    phase == .began || phase == .changed
  }
}

