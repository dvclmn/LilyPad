//
//  Model+Drawing.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation

struct DrawingGestureState: GestureTrackable {
  var requiredTouchCount: Int { return 1 }
  
  private(set) var isActive: Bool = false
  
  // Current drawing stroke
//  private(set) var currentStroke: [StrokePoint] = []
  
  // Track the previous touch for interpolation
  private var previousTouch: TouchPoint?
  
  mutating func update(eventData: TouchEventData, in rect: CGRect) {
    let touches = eventData.touches
    let phase = eventData.phase
    let pressure = eventData.pressure
    
    guard eventData.touches.count == requiredTouchCount else { return }
    let positions = TouchPositions.mapped(from: eventData.touches, to: rect)
    
    //    guard touches.count == 1, let touch = touches.first else {
    //      if phase == .ended || phase == .cancelled {
    //        // Finish the stroke
    //        isActive = false
    //      }
    //      return
    //    }
    //
    //    switch phase {
    //      case .began:
    //        isActive = true
    //        currentStroke = [createStrokePoint(from: touch, in: rect, pressure: pressure)]
    //        previousTouch = touch
    //
    //      case .moved:
    //        guard isActive else { return }
    //
    //        // Create intermediate points for smoother lines
    //        if let prev = previousTouch {
    //          let intermediatePoints = interpolate(
    //            from: prev,
    //            to: touch,
    //            pressure: pressure,
    //            in: rect
    //          )
    //          currentStroke.append(contentsOf: intermediatePoints)
    //        }
    //
    //        currentStroke.append(createStrokePoint(from: touch, in: rect, pressure: pressure))
    //        previousTouch = touch
    //
    //      case .ended, .cancelled:
    //        isActive = false
    //        previousTouch = nil
    //        // Finalize stroke, ready for rendering
    //    }
  }
}
