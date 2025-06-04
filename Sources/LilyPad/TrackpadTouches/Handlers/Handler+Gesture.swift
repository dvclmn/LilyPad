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

  public var lastTouchPair: TouchPair?

  public var currentGestureType: GestureType = .none
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

  public mutating func processGesture(_ rawGesture: RawGesture) {

    let gestureType = interpretGesture(rawGesture, lastTouchPair: lastTouchPair)
    
    
    self.currentGestureType = gestureType
    if let currentPair = TouchPair(rawGesture.touches), let lastPair = lastTouchPair {
      switch currentGestureType {
        case .pan:
          let delta = currentPair.midPointBetween - lastPair.midPointBetween
          pan += delta
        case .zoom:
          let delta = currentPair.distanceBetween - lastPair.distanceBetween
          zoom += delta / lastPair.distanceBetween
        case .rotate:
          let delta = currentPair.angleInRadiansBetween - lastPair.angleInRadiansBetween
          rotation += delta
        case .none:
          break
      }
    }
    
    

//    if rawGesture.phase == .began {
//      self.currentGestureType = gestureType
//    } else if rawGesture.phase == .changed {
//      if gestureType != .none {
////        self.currentGestureType = gestureType
//      }
//      
//      
//    } else if rawGesture.phase == .ended {
//      self.currentGestureType = .none
//    }
    
    // Always update the last touch pair for the next frame
    self.lastTouchPair = TouchPair(rawGesture.touches)
    
//    let gestureType = interpretGesture(rawGesture, lastTouchPair: lastTouchPair)
//
//    if rawGesture.phase == .began {
//      self.currentGestureType = gestureType
//    } else if rawGesture.phase == .changed {
//      if gestureType != .none {
//        self.currentGestureType = gestureType
//      }
//    } else if rawGesture.phase == .ended {
//      self.currentGestureType = .none
//    }
//
//    /// Update previous pair for next frame
//    self.lastTouchPair = TouchPair(rawGesture.touches)
  }

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

  public mutating func update(with touches: [MappedTouchPoint]) -> RawGesture? {
    /// Exiting early right up top to reduce noise
    guard touches.count > 1 else { return nil }

    let activeTouches: [MappedTouchPoint] = touches.filter { $0.phase != .ended && $0.phase != .cancelled }
    let activeTouchIDs = Set(activeTouches.map(\.id))

    print(
      "Currently \(activeTouches.count) active touches. Touches with Phases `ended` or `cancelled` are being ignored.")

    /// Start a new gesture if eligible (only if not already tracking touches)
    if activeTouchIDs.count == 2 && trackedTouchIDs.isEmpty {

      print(
        "Confirmed that there are exactly 2 active touches, and no existing tracked touch IDs. Starting new gesture")

      /// Set the current gesture id to a new unique ID
      let newGestureID = UUID()
      currentGestureID = newGestureID

      /// Update the active Touch IDs to be tracked
      trackedTouchIDs = activeTouchIDs

      return RawGesture(
        id: newGestureID,
//        phase: .began,
        touches: activeTouches
      )
    }

    print(
      "Cannot create a *new* gesture. Number of touches must be 2 (currently \(activeTouchIDs.count)), or there are touches already being tracked: \(trackedTouchIDs)."
    )

    /// Continue gesture if touches match
    if activeTouchIDs == trackedTouchIDs {

      print("The active touch IDs match the tracked touch IDs. Continuing the current \(currentGestureType) gesture.")
      guard let currentGestureID else {
        print("Couldn't get the `currentGestureID`")
        return nil
      }
      return RawGesture(
        id: currentGestureID,
//        phase: .changed,
        touches: activeTouches
      )
    }

    print("The active touch IDs do not match the tracked touch IDs. What happens next?")

    /// End the gesture if one or more tracked touches ended
    if !activeTouchIDs.isSuperset(of: trackedTouchIDs) {

      print(
        "Have determined that the active touch IDs are not a superset of the tracked touch IDs. Ending the current gesture."
      )

      guard let currentGestureID else {
        print("Couldn't get the `currentGestureID` blarp")
        return nil
      }
      let gesture = RawGesture(
        id: currentGestureID,
//        phase: .ended,
        touches: Array(activeTouches)
      )
      resetGestures()

      return gesture
    }

    /// Default case: nothing to report
    return nil
  }

  private func canTrackNewGesture(
    activeTouchIDs: Set<MappedTouchPoint.ID>
  ) -> Bool {
    return activeTouchIDs.count == 2 && trackedTouchIDs.isEmpty
  }


  private mutating func resetGestures() {
    currentGestureID = nil
    trackedTouchIDs = []

    print("Gestures were reset")
  }

  public func interpretGesture(
    _ rawGesture: RawGesture,
    lastTouchPair: TouchPair?
  ) -> GestureType {
    guard let touchPair = TouchPair(rawGesture.touches) else {
      return .none
    }

    guard let lastTouchPair else {
      return .none
    }

    let deltaPan = touchPair.midPointBetween - lastTouchPair.midPointBetween
    let deltaZoom = abs(touchPair.distanceBetween - lastTouchPair.distanceBetween)
    let deltaAngle = abs(touchPair.angleInRadiansBetween - lastTouchPair.angleInRadiansBetween)

    let zoomPassed = deltaZoom > zoomThreshold
    let rotatePassed = deltaAngle > rotationThreshold
    let panPassed = deltaPan.length > panThreshold

    /// Priority: pan > zoom > rotate
    if panPassed {
      return .pan
    } else if zoomPassed {
      return .zoom
    } else if rotatePassed {
      return .rotate
    }

    return .none
  }

}
