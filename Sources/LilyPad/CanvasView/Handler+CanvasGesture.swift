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
  /// I have switched to using `CGSize`, as this better
  /// expresses; *offset*. Not an absolute location
  var pan: CGSize = .zero
  var rotation: CGFloat = 0


  var hoveredPoint: CGPoint?
  let zoomRange: ClosedRange<Double>
  var currentPanPhase: PanPhase = .inactive
  var totalPanDistance: CGFloat = 0

  init(zoomRange: ClosedRange<Double> = 0.1...10) {
    self.zoomRange = zoomRange
  }
}

extension CanvasGestureHandler {
  func handlePanPhase(_ phase: PanPhase) {
    switch phase {
      case .inactive:
break
      case .active(let delta):
        /// Apply delta to canvas offset for real-time panning
        pan.width += delta.x
        pan.height += delta.y

        /// Track total distance for analytics/gesture recognition
        let distance = sqrt(delta.x * delta.x + delta.y * delta.y)
        totalPanDistance += distance

      case .ended(let finalDelta):
        /// Apply final delta
        pan.width += finalDelta.x
        pan.height += finalDelta.y

        /// Could add momentum/deceleration here
//        print("Pan gesture ended. Total distance: \(totalDistance)")

      case .cancelled:
        /// Could revert to previous state or handle cancellation
        print("Pan gesture cancelled")
    }
  }
  
  
}
