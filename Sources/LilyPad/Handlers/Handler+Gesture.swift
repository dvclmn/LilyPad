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

  public var currentGestureType: GestureType = .none

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

}
