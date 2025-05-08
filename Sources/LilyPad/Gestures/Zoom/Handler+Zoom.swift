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
  
  var panOffset: CGPoint = .zero
//  var zoomScale: CGFloat = 1.0
//  var rotationAngle: CGFloat = .zero
//  var gestureState = TrackpadGestureState()
//  var panState = PanGestureState()
  
//  var offset: CGPoint = .zero
  var startPositions: TouchPositions?
  var lastPanAmount: CGPoint = .zero
  var isPanActive = false
  
  
//  var zoomState = ZoomGestureState()
//  var rotationState = RotateGestureState()
  
//  var scale: CGFloat = 1
//  var offset: CGPoint = .zero
  var canvasSize: CGSize = .zero
  
  var viewportSize: CGSize = .zero
  
//  var panGestureInProgress = false
//  var gestureStartPositions: TouchPositions?
//  var lastPanAmount: CGPoint = .zero
//  var lastScale: CGFloat = 1.0
  
}

extension ZoomHandler {
  
  func updatePan(event: TouchEventData, in rect: CGRect) {
    
    print("Let's update the pan")
    guard event.touches.count == 2 else {
      print("PanGesture requires exactly 2 touches")
      return
    }
    let positions = TouchPositions.mapped(from: event.touches, to: rect)
    
    switch event.phase {
      case .began:
        print("Phase: `began`")
        startPositions = positions
        //        offset = .zero
        isPanActive = true
//        return lastPanAmount
        
      case .moved:
        print("Phase: `moved`")
        guard let start = startPositions else {
          print("PanGesture: No value found for `startPositions`")
          return
        }
        
        let delta = positions.midPoint - start.midPoint
        //        let deltaDistance = abs(positions.distanceBetween - start.distanceBetween)
        
        //        if deltaDistance > zoomThreshold {
        //          let scaleChange = currentPair.distanceBetween / start.distanceBetween
        //          store.scale = lastScale * scaleChange
        //        } else {
        //          // Don't update scale if zoom motion is below threshold
        //          store.scale = lastScale
        //        }
        
        let result = lastPanAmount + delta
        panOffset = result
        
      case .ended, .cancelled, .none:
        print("Phase: `ended`, `cancelled` or `none`")
        lastPanAmount = panOffset
        isPanActive = false
        startPositions = nil
    }
  }
  
//  func updateGesture(event: TouchEventData, in rect: CGRect) {
//    print("Updated gesture state")
//    panOffset = panState.update(event: event, in: rect)
//    zoomScale = zoomState.update(event: event, in: rect)
//    rotationAngle = rotationState.update(event: event, in: rect)
//    //    drawing.update(event: event, in: rect)
//  }
  
  var canvasPosition: CGPoint {

    let viewportMidPoint = viewportSize.midpoint
//    let canvasMidPoint = canvasSize.midpoint
    
    let centred = viewportMidPoint
    return panOffset + centred
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

