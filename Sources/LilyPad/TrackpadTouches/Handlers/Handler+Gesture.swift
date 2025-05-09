//
//  Gesture+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import BaseHelpers
import Foundation

struct GestureStateHandler {

  //  var activeGestures: Set<GestureType> = []

  /// Current values
  var pan: CGPoint = .zero
  var zoom: CGFloat = 1.0
  var rotation: CGFloat = 0.0
  
  /// Last-updated values
  var lastPan: CGPoint = .zero
  var lastZoom: CGFloat = 1.0
  var lastRotation: CGFloat = .zero

  var startTouchPositions: TouchPositions?
  
  let zoomThreshold: CGFloat = 50
  let requiredTouchCount: Int = 2
  
  mutating func update(event: TouchEventData, in rect: CGRect) {
    
    guard event.touches.count == 2 else {
      print("Gesture requires exactly 2 touches")
      return
    }
    let touchPositions = TouchPositions.mapped(from: event.touches, to: rect)
    
    switch event.phase {
      case .began:
        //        print("Phase: `began`")
        startTouchPositions = touchPositions
        
        
      case .moved:
        //        print("Phase: `moved`")
        guard let start = startTouchPositions else {
          print("Gesture: No value found for `startPositions`")
          return
        }
        
#warning(
        "Should try a callback here, that asks the conforming type (e.g. Zoom) to provide *it's* own way to calculate a delta"
        )
        let deltaPan = touchPositions.midPoint - start.midPoint
        let deltaDistance = abs(touchPositions.distanceBetween - start.distanceBetween)
        
        if deltaDistance > zoomThreshold {
          let scaleChange = touchPositions.distanceBetween / start.distanceBetween
          
          zoom = lastZoom * scaleChange
        } else {
          // Don't update scale if zoom motion is below threshold
          zoom = lastZoom
        }
        
        pan = lastPan + deltaPan
        
      case .ended, .cancelled, .none:
        //        print("Phase: `ended`, `cancelled` or `none`")
        lastPan = pan
        startTouchPositions = nil
    }
    
    
  }
  
  
//
//  var pan = PanGestureState()
//  var zoom = ZoomGestureState()
  //  var rotation = RotateGestureState()
  //  var drawing = DrawingGestureState()

  /// The space to which touch points are mapped (e.g., canvas or viewport)
  //  var mappingRect: CGRect = .zero

//  mutating func update(event: TouchEventData, in rect: CGRect) {
//    pan.update(event: event, in: rect)
//    zoom.update(event: event, in: rect)
//    //    rotation.update(event: event, in: rect)
//    //    drawing.update(event: event, in: rect)
//  }

  /// Something worth considering — a default cascade of gesture types?
  /// Though they *can* be simultaneous, so maybe this isn't the way to go.
  ///
  /// Though could maintain a `Set<ActiveGesture>`?
  ///
  /// 1. Drawing as default
  /// 2. If not drawing then Panning (e.g. *two* fingers?
  ///   But what if wanting to *draw* with two fingers?). Can set a tool for that in the UI.
  /// 3. If touches pinch and spread, then Zooming
  /// 4. If
  //  func determineActiveGestures(event: TouchEventData) -> Set<GestureType> {

  /// What are the rules?
  ///
  /// Drawing: By default, only one touch. With a tool selected, multiple touches allowed
  /// Pan: 2x touches. The default/defacto two-finger gesture type. Should be easiest to invoke
  /// Zoom: 2x touches. Detected when finger distance changes sufficiently (past threshold)
  /// Rotate: 2x touches. Similar to above, but change in rotation between the two touches


  //  }
}
