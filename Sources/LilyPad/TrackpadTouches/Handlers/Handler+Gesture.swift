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

  var startTouchPair: TouchPair?
  
  #warning("I 'feel' like this is useful, but not 100% sure. Leaving here for now in case.")
//  var currentTouchPositions: TouchPositions?


  var gestureType: GestureType = .none

  let zoomThreshold: CGFloat = 20
  let panThreshold: CGFloat = 10
  let rotationThreshold: CGFloat = .pi / 30  // ~6 degrees
  let requiredTouchCount: Int = 2

  public init() {}
}

extension GestureStateHandler {

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
    event: TouchEventData,
    in mappingRect: CGRect
  ) {

    guard event.touches.count == requiredTouchCount,
    let touchPositions = TouchPair(event.touches, mappingRect: mappingRect)
    else { return }

    switch event.phase {
      case .began:
        startTouchPair = touchPositions
//        currentTouchPositions = touchPositions
        gestureType = .none

      case .moved:
        guard let start = startTouchPair else {
          print("Gesture: No value found for `startPositions`")
          return
        }

//        currentTouchPositions = touchPositions

        let deltaPan = touchPositions.midPointBetween - start.midPointBetween
        let deltaZoom = abs(touchPositions.distanceBetween - start.distanceBetween)
        let deltaAngle = abs(touchPositions.angleInRadiansBetween - start.angleInRadiansBetween)

        if gestureType == .none {
          let zoomPassed = deltaZoom > zoomThreshold
          let rotatePassed = deltaAngle > rotationThreshold
          let panPassed = deltaPan.length > panThreshold

          /// Priority: pan > zoom > rotate
          if panPassed {
            gestureType = .pan
            print("Now Panning: Pan delta `\(deltaPan)` crossed threshold `\(panThreshold)`")
          } else if zoomPassed {
            gestureType = .zoom
            print("Now Zooming: Zoom delta `\(deltaZoom)` crossed threshold `\(zoomThreshold)`")
          } else if rotatePassed {
            gestureType = .rotate
            print("Now Rotating: Rotation delta `\(deltaAngle)` crossed threshold `\(rotationThreshold)`")
          }
        }

        switch gestureType {
          case .zoom:
            let scaleChange = touchPositions.distanceBetween / start.distanceBetween
            zoom = lastZoom * scaleChange
          case .rotate:
            rotation = lastRotation + (touchPositions.angleInRadiansBetween - start.angleInRadiansBetween)
          case .pan:
            pan = lastPan + deltaPan
          case .none, .draw:
            break  // Wait for threshold to be crossed
        }

      case .ended, .cancelled, .none:
        lastPan = pan
        lastZoom = zoom
        lastRotation = rotation
        startTouchPair = nil
//        currentTouchPositions = nil
        gestureType = .none
    }
  }
}
