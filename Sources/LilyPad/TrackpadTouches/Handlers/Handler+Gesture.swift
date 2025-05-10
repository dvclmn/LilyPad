//
//  Gesture+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import BaseHelpers
import Foundation

public struct GestureStateHandler {

  /// Current values
  public var pan: CGPoint = .zero
  public var zoom: CGFloat = 1.0
  public var rotation: CGFloat = .zero

  /// Last-updated values
  var lastPan: CGPoint = .zero
  var lastZoom: CGFloat = 1.0
  var lastRotation: CGFloat = .zero

  var startTouchPositions: TouchPositions?
  var gestureType: GestureType = .none

  let zoomThreshold: CGFloat = 20
  let panThreshold: CGFloat = 10
  let rotationThreshold: CGFloat = .pi / 30  // ~6 degrees
  let requiredTouchCount: Int = 2

  public init() {}

  public mutating func update(event: TouchEventData, inViewSize rect: CGRect) {

    guard event.touches.count == requiredTouchCount else { return }
    let touchPositions = TouchPositions.mapped(from: event.touches, to: rect)

    switch event.phase {
      case .began:
        startTouchPositions = touchPositions
        gestureType = .none

      case .moved:
        guard let start = startTouchPositions else {
          print("Gesture: No value found for `startPositions`")
          return
        }

        let deltaPan = touchPositions.midPoint - start.midPoint
        let deltaZoom = abs(touchPositions.distanceBetween - start.distanceBetween)
        let deltaAngle = abs(touchPositions.angleBetween - start.angleBetween)

        /// Decide gesture type if undecided
        if gestureType == .none {
          if deltaZoom > zoomThreshold {
            print("Zoom delta: `\(deltaZoom)` crossed threshold `\(zoomThreshold)`")
            gestureType = .zoom
          } else if deltaAngle > rotationThreshold {
            print("Rotation delta: `\(deltaAngle)` crossed threshold `\(rotationThreshold)`")
            gestureType = .rotate
          } else if deltaPan.length > panThreshold {
            print("Zoom delta: `\(deltaZoom)` crossed threshold `\(zoomThreshold)`")
            gestureType = .pan
          }
        }

        //        if deltaDistance > zoomThreshold {
        //          let scaleChange = touchPositions.distanceBetween / start.distanceBetween
        //
        //          zoom = lastZoom * scaleChange
        //        } else {
        //          // Don't update scale if zoom motion is below threshold
        //          zoom = lastZoom
        //        }

        switch gestureType {
          case .zoom:
            let scaleChange = touchPositions.distanceBetween / start.distanceBetween
            zoom = lastZoom * scaleChange
          case .rotate:
            rotation = lastRotation + (touchPositions.angleBetween - start.angleBetween)
          case .pan:
            pan = lastPan + deltaPan
          case .none, .draw:
            break  // Wait for threshold to be crossed
        }

      //        pan = lastPan + deltaPan

      case .ended, .cancelled, .none:
        lastPan = pan
        lastZoom = zoom
        lastRotation = rotation
        startTouchPositions = nil
        gestureType = .none
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
