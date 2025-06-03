//
//  Gesture+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import BaseHelpers
import Foundation
import SwiftUI

public struct GestureStateHandler {

  /// Current values
  public var pan: CGPoint = .zero
  public var zoom: CGFloat = 1.0
  public var rotation: CGFloat = .zero

  /// Last-updated values
  var lastPan: CGPoint = .zero
  var lastZoom: CGFloat = 1.0
  var lastRotation: CGFloat = .zero

  public var previousPair: TouchPair?

  #warning("I 'feel' like this is useful, but not 100% sure. Leaving here for now in case.")
  //  var currentTouchPositions: TouchPositions?

  public var gestureType: GestureType = .none
  var currentGestureID: TrackpadGesture.ID?

  private var trackedTouchIDs: Set<TouchPoint.ID> = []

  let zoomThreshold: CGFloat = 20
  let panThreshold: CGFloat = 10
  let rotationThreshold: CGFloat = .pi / 30  // ~6 degrees
  let requiredTouchCount: Int = 2

  public init() {}
}

extension GestureStateHandler {

  public var hasPanned: Bool {
    !self.pan.isZero
  }

  public var hasZoomed: Bool {
    self.zoom != 1.0
  }

  public var hasRotated: Bool {
    !self.rotation.isZero
  }

  #warning("This is still probably useful, but I'm doing a tidy, and hiding for simplicity for a while")
  //  public func currentTouchesMidpoint(in viewSize: CGSize) -> UnitPoint {
  //    guard let currentTouchPositions else { return .center }
  //    return currentTouchPositions.midPoint.unitPoint(in: viewSize)
  //  }

  public mutating func resetValue(for gestureType: GestureType) {
    switch gestureType {
      case .pan:
        pan = .zero
      case .zoom:
        zoom = 1.0
      case .rotate:
        rotation = .zero
      default:
        break
    }
  }

  public mutating func update(
    with touches: [MappedTouchPoint]
      //    with touches: Set<TouchPoint>
  ) -> RawGesture? {
    let activeTouches: [MappedTouchPoint] = touches.filter { $0.phase != .ended && $0.phase != .cancelled }
    let activeTouchIDs = Set(activeTouches.map(\.id))

    /// Start a new gesture if eligible (only if not already tracking touches)
    if activeTouchIDs.count == 2 && trackedTouchIDs.isEmpty {

      /// Set the current gesture id to a new unique ID
      let newGestureID = UUID()
      currentGestureID = newGestureID

      /// Update the active Touch IDs to be tracked
      trackedTouchIDs = activeTouchIDs

      return RawGesture(
        id: newGestureID,
        phase: .began,
        touches: activeTouches
      )
    }

    /// Continue gesture if touches match
    if activeTouchIDs == trackedTouchIDs {

      guard let currentGestureID else { return nil }
      return RawGesture(
        id: currentGestureID,
        phase: .changed,
        touches: activeTouches
      )

    }

    /// End the gesture if one or more tracked touches ended
    if !activeTouchIDs.isSuperset(of: trackedTouchIDs) {
      guard let currentGestureID else { return nil }
      let gesture = RawGesture(id: currentGestureID, phase: .ended, touches: Array(activeTouches))
      resetGestures()
      return gesture
    }

    /// Default case: nothing to report
    return nil
  }

  private mutating func resetGestures() {
    currentGestureID = nil
    trackedTouchIDs = []
  }


  public func interpretGesture(
    _ rawGesture: RawGesture,
    previousPair: TouchPair?
  ) -> GestureType {
    print(
      "Let's interpret this 'raw' gesture. It has \(rawGesture.touches.count) touches, and a gesture phase of \(rawGesture.phase.rawValue)"
    )
    let touches = rawGesture.touches
    let phase = rawGesture.phase

    /// The init for `TouchPair` is failable, and checks number of touches for us
    guard let touchPair = TouchPair(touches) else {
      print("Two touches required to form a valid `TouchPair`, found \(touches.count).")
      return .none
    }
    
    


    //    startTouchPair = touchPositions

    guard let previousPair else {
      print("Gesture: No value found for `startPositions`")
      return .none
    }

    let deltaPan = touchPair.midPointBetween - previousPair.midPointBetween
    let deltaZoom = abs(touchPair.distanceBetween - touchPair.distanceBetween)
    let deltaAngle = abs(touchPair.angleInRadiansBetween - touchPair.angleInRadiansBetween)


    //    switch phase {
    //      case .began:
    //
    //        //        currentTouchPositions = touchPositions
    //        gestureType = .unknown
    //
    //      case .moved, .stationary:
    //
    //
    //        //        currentTouchPositions = touchPositions
    //
    //

    if gestureType == .none {
      let zoomPassed = deltaZoom > zoomThreshold
      let rotatePassed = deltaAngle > rotationThreshold
      let panPassed = deltaPan.length > panThreshold

      /// Priority: pan > zoom > rotate
      if panPassed {
        //        gestureType = .pan
        print("Now Panning: Pan delta `\(deltaPan)` crossed threshold `\(panThreshold)`")
        return .pan

      } else if zoomPassed {
        //        gestureType = .zoom
        print("Now Zooming: Zoom delta `\(deltaZoom)` crossed threshold `\(zoomThreshold)`")
        return .zoom

      } else if rotatePassed {
        //        gestureType = .rotate
        print("Now Rotating: Rotation delta `\(deltaAngle)` crossed threshold `\(rotationThreshold)`")
        return .rotate
      }
    }

    return .none
  }

  //  public func updateGesture(event: TouchEventData) -> TrackpadGesture? {
  //    let touches = event.touches
  //    let activeTouches = touches.filter { $0.phase != .ended && $0.phase != .cancelled }
  //
  //    guard activeTouches.count == 2 else {
  //      return nil
  //    }
  //
  //    let phases = Set(activeTouches.map(\.phase))
  //
  //    if phases.contains(.began) {
  //      return TrackpadGesture(id: currentGestureID, phase: .began, touches: activeTouches)
  //    } else if phases.contains(.moved) {
  //      return TrackpadGesture(id: currentGestureID, phase: .changed, touches: activeTouches)
  //    } else if phases.allSatisfy({ $0 == .stationary }) {
  //      return TrackpadGesture(id: currentGestureID, phase: .changed, touches: activeTouches)
  //    } else {
  //      return nil
  //    }
  //
  //  }
  //
  //  func onTouchesChanged(event: TouchEventData) {
  //    let touches = event.touches
  //    let ended = touches.filter { $0.phase == .ended || $0.phase == .cancelled }
  //
  //    if gestureInProgress && gestureTouches.intersects(ended.map(\.id)) {
  //      currentGesture = Gesture(id: gestureID, phase: .ended, touches: [])
  //    }
  //  }


}
