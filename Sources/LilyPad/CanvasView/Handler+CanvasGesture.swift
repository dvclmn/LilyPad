//
//  Handler+CanvasGesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

@Observable
final class CanvasGestureHandler {
  var zoom: CGFloat = 1
  var pan: CGPoint = .zero
  var rotation: CGFloat = 0

  /// Pan
  var currentPanPhase: PanPhase = .inactive
  var totalDistance: CGFloat = 0

  init() {

  }
}

extension CanvasGestureHandler {
  func handlePanPhase(_ phase: PanPhase) {
    switch phase {
      case .inactive:
break
      case .active(let delta):
        /// Apply delta to canvas offset for real-time panning
        pan.x += delta.x
        pan.y += delta.y

        /// Track total distance for analytics/gesture recognition
        let distance = sqrt(delta.x * delta.x + delta.y * delta.y)
        totalDistance += distance

      case .ended(let finalDelta):
        /// Apply final delta
        pan.x += finalDelta.x
        pan.y += finalDelta.y

        /// Could add momentum/deceleration here
        print("Pan gesture ended. Total distance: \(totalDistance)")

      case .cancelled:
        /// Could revert to previous state or handle cancellation
        print("Pan gesture cancelled")
    }
  }
  
  
}
