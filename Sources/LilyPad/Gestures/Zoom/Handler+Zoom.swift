//
//  Handler+Zoom.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI
import BaseHelpers

@Observable
final class ZoomHandler {
//  var touches: Set<TouchPoint> = []
  var eventData: TouchEventData = .initial
  
  var gestureState = TrackpadGestureState()
  
  var scale: CGFloat = 1
  var offset: CGPoint = .zero
  var canvasSize: CGSize = .zero
  
  var viewportSize: CGSize = .zero
  
  var panGestureInProgress = false
  var gestureStartPositions: TouchPositions?
  var lastPanAmount: CGPoint = .zero
  var lastScale: CGFloat = 1.0
  
}

extension ZoomHandler {
  
  var canvasPosition: CGPoint {

    let viewportMidPoint = viewportSize.midpoint
//    let canvasMidPoint = canvasSize.midpoint
    
    let centred = viewportMidPoint
    return offset + centred
  }
  
//  func panAmount(touches: Set<TouchPoint>, phase: TrackpadGesturePhase) {
//    guard touches.count == 2 else {
//      return
//    }
//    
//    let currentPair = TouchPositions.mapped(from: touches, to: viewportSize.toCGRect)
//    
//    switch phase {
//      case .began:
//        // Start of gesture — remember the touch points and where the view was
//        gestureStartPositions = currentPair
//        lastPanAmount = store.offset
//        lastScale = store.scale
//        
//      case .changed:
//        guard let start = gestureStartPositions else { return }
//        
//        let delta = currentPair.midPoint - start.midPoint
//        let deltaDistance = abs(currentPair.distanceBetween - start.distanceBetween)
//        
//        
//        
//        // Add delta to previous offset
//        store.offset = lastPanAmount + delta
//        
//        if deltaDistance > zoomThreshold {
//          let scaleChange = currentPair.distanceBetween / start.distanceBetween
//          store.scale = lastScale * scaleChange
//        } else {
//          // Don't update scale if zoom motion is below threshold
//          store.scale = lastScale
//        }
//        
//        //        store.scale = lastScale * scaleChange
//        
//      case .ended, .cancelled:
//        gestureStartPositions = nil
//    }
//  }
}

