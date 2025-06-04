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

  public var initialTouchPair: TouchPair?
  public var lastTouchPair: TouchPair?
  public var currentTouchPair: TouchPair?
  //  public var lastTouchPair: TouchPair?

  public var currentGestureType: GestureType = .none
  //  var currentGestureID: TrackpadGesture.ID?
  //  private var trackedTouchIDs: Set<TouchPoint.ID> = []


  //  let requiredTouchCount: Int = 2

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

  

  public mutating func processGesture(touches: [MappedTouchPoint]) throws {

//    print(
//      "Processing touches, for GestureHandler. Initial Pair should be *the same* for every frame: \(self.initialTouchPair?.idsForComparison ?? "nil")"
//    )
    
    do {
      try recogniseGesture(touches: touches)
    
      /// We'll only be able to update any pan/zoom/rotate values,
      /// if we have current and initial touch pairs
      if let currentTouchPair, let lastTouchPair {
        print("Current and last touch pairs exist")
        switch self.currentGestureType {
          case .none:
            break
          case .pan:
            updatePan(
              currentTouchPair: currentTouchPair,
              lastTouchPair: lastTouchPair
            )
          case .zoom:
            break
          case .rotate:
            break
        }
      } else {
      print("Couldn't get value for currentTouchPair or initialTouchPair")
      }
      
    } catch {
//      print("Gesture Error: \(error)")
    }

  }
  
  private mutating func updatePan(
    currentTouchPair: TouchPair,
    lastTouchPair: TouchPair
//    initialTouchPair: TouchPair,
  ) {
    let currentPairMidPoint: CGPoint = currentTouchPair.midPointBetween
    let lastPairMidPoint: CGPoint = lastTouchPair.midPointBetween
    
//    let currentPanAmount = self.pan
//    let newPanAmount = currentPanAmount + currentPairMidPoint - lastPairMidPoint
//    self.pan = newPanAmount
    
    /// Calculate the movement since the last frame
    let frameDelta = currentPairMidPoint - lastPairMidPoint
    
    /// Add this frame's movement to the current pan
    let currentPanAmount = self.pan
    let newPanAmount = currentPanAmount + frameDelta
    self.pan = newPanAmount
    
    print("""
    Current pan amount: \(currentPanAmount)
    
    Current pair midpoint: \(currentPairMidPoint)
    Last pair midpoint: \(lastPairMidPoint)
    
    Updated pan amount: \(self.pan)
    """)
//    self.pan = CGPoint(
//      x: currentPairMidPoint.0 - initialPairMidPoint.0,
//      y: currentPairMidPoint.1 - initialPairMidPoint.1
//    )
    
  }
  

  private mutating func recogniseGesture(touches: [MappedTouchPoint]) throws {
    
    /// Validate touch count
    guard touches.count == 2 else {
      self.currentGestureType = .none
      self.initialTouchPair = nil
      self.lastTouchPair = nil
      throw GestureError.touchesNotEqualToTwo
    }
    
    /// Create current touch pair
    guard let currentPair = TouchPair(touches, referencePair: self.currentTouchPair) else {
      self.currentGestureType = .none
      self.initialTouchPair = nil
      throw GestureError.touchesNotEqualToTwo
    }
    
    /// Always update touch pair tracking
    self.lastTouchPair = self.currentTouchPair
    self.currentTouchPair = currentPair
    
    /// Handle gesture state
    switch self.currentGestureType {
      case .none:
        /// Try to recognize a new gesture
        if let initialPair = self.initialTouchPair {
          let gestureType = GestureType(
            currentTouchPair: currentPair,
            initialPair: initialPair
          )
          self.currentGestureType = gestureType
        } else {
          self.initialTouchPair = currentPair
        }
        
      default:
        /// Gesture in progress - just continue (touch pairs already updated)
        break
    }
  }
  
//  private mutating func recogniseGesture(touches: [MappedTouchPoint]) throws {
//    
//    /// First, always validate and update the current touch pair
//    guard
//      let currentPair = TouchPair(
//        touches,
//        referencePair: self.currentTouchPair
//      )
//    else {
//      self.currentGestureType = .none
//      self.initialTouchPair = nil
//      throw GestureError.touchesNotEqualToTwo
//    }
//    
//    // Always update lastTouchPair before updating currentTouchPair
//    self.lastTouchPair = self.currentTouchPair
//    self.currentTouchPair = currentPair
//    
//    // Handle gesture recognition
//    if self.currentGestureType == .none {
//      // No gesture in progress - try to recognize one
//      if let initialPair = self.initialTouchPair {
//        // We have an initial pair, so determine gesture type
//        let gestureType = GestureType(
//          currentTouchPair: currentPair,
//          initialPair: initialPair
//        )
//        self.currentGestureType = gestureType
//      } else {
//        // First frame - set initial pair
//        self.initialTouchPair = currentPair
//      }
//    } else {
//      // Gesture already in progress - validate we still have 2 touches
//      if touches.count != 2 {
//        self.currentGestureType = .none
//        self.initialTouchPair = nil
//        self.lastTouchPair = nil
//        throw GestureError.touchesNotEqualToTwo
//      }
//      // Otherwise, just continue with the existing gesture
//      // (currentTouchPair and lastTouchPair are already updated above)
//    }
//    
////    guard self.currentGestureType == .none else {
////      /// There is already a Gesture in progress
////      if touches.count != 2 {
////        self.currentGestureType = .none
////        self.initialTouchPair = nil
////        throw GestureError.touchesNotEqualToTwo
////      } else {
////        return
////      }
////    }
////    
////    /// Providing the current touch pair here in the TouchPair init
////    /// in an attempt to keep the gesture touches stable across lifecycle
////    guard
////      let currentPair = TouchPair(
////        touches,
////        referencePair: self.currentTouchPair
////      )
////    else {
////      self.currentGestureType = .none
////      self.initialTouchPair = nil
////      throw GestureError.touchesNotEqualToTwo
////      
////    }
////    
////    self.currentTouchPair = currentPair
////    
////    /// Let's check, do we have an initial (first) pair, as a reference point
////    /// to calculate deltas, to identify gesture type?
////    if let initialPair = self.initialTouchPair {
////      
////      /// If so, let's use `GestureType`s initialiser to get the type
////      let gestureType = GestureType(
////        currentTouchPair: currentPair,
////        initialPair: initialPair
////      )
////      self.currentGestureType = gestureType
////    } else {
////      /// We only update the initial pair on the very first pass,
////      /// whereas `lastTouchPair`, as below, is updated every frame
////      initialTouchPair = currentPair
////    }
////    
////    lastTouchPair = currentPair
//    
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

  //  public mutating func update(with touches: [MappedTouchPoint]) -> RawGesture? {
  //    /// Exiting early right up top to reduce noise
  //    guard touches.count > 1 else { return nil }
  //
  //    let activeTouches: [MappedTouchPoint] = touches.filter { $0.phase != .ended && $0.phase != .cancelled }
  //    let activeTouchIDs = Set(activeTouches.map(\.id))
  //
  //    print(
  //      "Currently \(activeTouches.count) active touches. Touches with Phases `ended` or `cancelled` are being ignored.")
  //
  //    /// Start a new gesture if eligible (only if not already tracking touches)
  //    if activeTouchIDs.count == 2 && trackedTouchIDs.isEmpty {
  //
  //      print(
  //        "Confirmed that there are exactly 2 active touches, and no existing tracked touch IDs. Starting new gesture")
  //
  //      /// Set the current gesture id to a new unique ID
  //      let newGestureID = UUID()
  //      currentGestureID = newGestureID
  //
  //      /// Update the active Touch IDs to be tracked
  //      trackedTouchIDs = activeTouchIDs
  //
  //      return RawGesture(
  //        id: newGestureID,
  //        //        phase: .began,
  //        touches: activeTouches
  //      )
  //    }
  //
  //    print(
  //      "Cannot create a *new* gesture. Number of touches must be 2 (currently \(activeTouchIDs.count)), or there are touches already being tracked: \(trackedTouchIDs)."
  //    )
  //
  //    /// Continue gesture if touches match
  //    if activeTouchIDs == trackedTouchIDs {
  //
  //      print("The active touch IDs match the tracked touch IDs. Continuing the current \(currentGestureType) gesture.")
  //      guard let currentGestureID else {
  //        print("Couldn't get the `currentGestureID`")
  //        return nil
  //      }
  //      return RawGesture(
  //        id: currentGestureID,
  //        //        phase: .changed,
  //        touches: activeTouches
  //      )
  //    }
  //
  //    print("The active touch IDs do not match the tracked touch IDs. What happens next?")
  //
  //    /// End the gesture if one or more tracked touches ended
  //    if !activeTouchIDs.isSuperset(of: trackedTouchIDs) {
  //
  //      print(
  //        "Have determined that the active touch IDs are not a superset of the tracked touch IDs. Ending the current gesture."
  //      )
  //
  //      guard let currentGestureID else {
  //        print("Couldn't get the `currentGestureID` blarp")
  //        return nil
  //      }
  //      let gesture = RawGesture(
  //        id: currentGestureID,
  //        //        phase: .ended,
  //        touches: Array(activeTouches)
  //      )
  //      resetGestures()
  //
  //      return gesture
  //    }
  //
  //    /// Default case: nothing to report
  //    return nil
  //  }

  //  private func canTrackNewGesture(
  //    activeTouchIDs: Set<MappedTouchPoint.ID>
  //  ) -> Bool {
  //    return activeTouchIDs.count == 2 && trackedTouchIDs.isEmpty
  //  }
  //
  //
  //  private mutating func resetGestures() {
  //    currentGestureID = nil
  //    trackedTouchIDs = []
  //
  //    print("Gestures were reset")
  //  }

  //  public func interpretGesture(
  //    _ rawGesture: RawGesture,
  //    lastTouchPair: TouchPair?
  //  ) -> GestureType {
  //    guard let touchPair = TouchPair(rawGesture.touches) else {
  //      return .none
  //    }
  //
  //    guard let lastTouchPair else {
  //      return .none
  //    }
  //
  //
  //
  //    /// Priority: pan > zoom > rotate
  //    if panPassed {
  //      return .pan
  //    } else if zoomPassed {
  //      return .zoom
  //    } else if rotatePassed {
  //      return .rotate
  //    }
  //
  //    return .none
  //  }

}
