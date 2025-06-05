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

  public var currentGesture: TrackpadGesture?


  public init() {}
}

extension GestureStateHandler {

  public mutating func processGesture(
    touches: [MappedTouchPoint],
    zoomRange: ClosedRange<Double>
  ) throws {

    try recogniseGesture(touches: touches)

    /// We'll only be able to update any pan/zoom/rotate values,
    /// if we have current and initial touch pairs
    if let currentTouchPair, let lastTouchPair {
      switch self.currentGesture?.type {
       
        case .pan:
          updatePan(
            currentTouchPair: currentTouchPair,
            lastTouchPair: lastTouchPair
          )
        case .zoom:
          updateZoomLogarithmic(
            currentTouchPair: currentTouchPair,
            lastTouchPair: lastTouchPair,
            zoomRange: zoomRange
          )
        case .rotate, .none:
          break
          
      }
    } else {
      print("Couldn't get value for currentTouchPair or initialTouchPair")
    }
  }

  private mutating func updatePan(
    currentTouchPair: TouchPair,
    lastTouchPair: TouchPair
  ) {
    let currentPairMidPoint: CGPoint = currentTouchPair.midPointBetween
    let lastPairMidPoint: CGPoint = lastTouchPair.midPointBetween

    /// Calculate the movement since the last frame
    let frameDelta = currentPairMidPoint - lastPairMidPoint

    /// Add this frame's movement to the current pan
    let currentPanAmount = self.pan
    let newPanAmount = currentPanAmount + frameDelta
    self.pan = newPanAmount

    print(
      """
      Current pan amount: \(currentPanAmount)

      Current pair midpoint: \(currentPairMidPoint)
      Last pair midpoint: \(lastPairMidPoint)

      Updated pan amount: \(self.pan)
      """)

  }

  private mutating func updateZoomLogarithmic(
    currentTouchPair: TouchPair,
    lastTouchPair: TouchPair,
    zoomRange: ClosedRange<Double>
  ) {
    let currentDistance = currentTouchPair.distanceBetween
    let lastDistance = lastTouchPair.distanceBetween

    guard lastDistance > 0 else { return }

    let scaleFactor = currentDistance / lastDistance

    /// Use logarithmic scaling for more natural feel
    let logScale = log(scaleFactor)

    /// Adjust this to taste
    let zoomSensitivity: CGFloat = 2.4

    let currentZoom = self.zoom
    let newZoom = currentZoom * exp(logScale * zoomSensitivity)

    self.zoom = max(zoomRange.lowerBound, min(zoomRange.upperBound, newZoom))
  }

  //  private mutating func updateZoom(
  //    currentTouchPair: TouchPair,
  //    lastTouchPair: TouchPair
  //  ) {
  //    let current = currentTouchPair.distanceBetween
  //    let last = lastTouchPair.distanceBetween
  //
  //    /// Calculate the movement since the last frame
  //    let frameDelta = current - last
  //
  //    /// Add this frame's movement to the current pan
  //    let currentZoom = self.zoom
  //    let newZoom = currentZoom + frameDelta
  //    self.zoom = newZoom
  //  }


  private mutating func recogniseGesture(touches: [MappedTouchPoint]) throws {

    /// Validate touch count
    guard touches.count == 2 else {
      self.currentGesture = nil
      self.initialTouchPair = nil
      self.lastTouchPair = nil
      throw GestureError.touchesNotEqualToTwo
    }

    /// Create current touch pair
    guard
      let newCurrentPair = TouchPair(
        touches,
        previousPair: self.currentTouchPair
      )
    else {
      self.currentGesture = nil
      self.initialTouchPair = nil
      throw GestureError.touchesNotEqualToTwo
    }

    /// Always update touch pair tracking
    self.lastTouchPair = self.currentTouchPair
    self.currentTouchPair = newCurrentPair

    /// Handle gesture state
    //    switch self.currentGesture?.type {
    //      case .none:
    if self.currentGesture == nil {
      /// Try to recognize a new gesture
      if let initialPair = self.initialTouchPair,
        let gestureType = GestureType(
          currentTouchPair: newCurrentPair,
          initialPair: initialPair
        )
      {

        self.currentGesture = TrackpadGesture(
          id: UUID(),
          type: gestureType,
          phase: .moved,
          touches: newCurrentPair
        )
      } else {
        self.initialTouchPair = newCurrentPair
      }
    }

    //      default:
    /// Gesture in progress - just continue (touch pairs already updated)
    //        break
    //    }
  }

  public mutating func resetValue(for gestureType: GestureType) {
    switch gestureType {
      case .pan:
        pan = .zero
      case .zoom:
        zoom = 1.0
      case .rotate:
        rotation = .zero
    //      default:
    //        break
    }
  }

  public var hasPanned: Bool {
    !self.pan.isZero
  }
  
  public var hasZoomed: Bool {
    self.zoom != 1.0
  }
  
  public var hasRotated: Bool {
    !self.rotation.isZero
  }

}
