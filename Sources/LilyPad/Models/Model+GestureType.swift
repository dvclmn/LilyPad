//
//  Model+Gesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import AppKit
import BaseHelpers

public enum GestureType: String, Sendable {
  case none
  case pan
  case zoom
  case rotate

  init(
    currentTouchPair: TouchPair,
    initialPair: TouchPair
  ) {

    /// Movement across the screen. Used to detect panning
    let translationThreshold: CGFloat = 10

    /// Distance between fingers. Are we zooming?
    let distanceThreshold: CGFloat = 10

    /// Change in rotation of line drawn between fingers
    let rotationThreshold: CGFloat = .pi / 30

    let deltaTranslation: CGFloat = Self.translationDistance(
      from: initialPair,
      to: currentTouchPair
    )
    let deltaPinchDistance: CGFloat = abs(currentTouchPair.distanceBetween - initialPair.distanceBetween)
    let deltaAngle: CGFloat = abs(currentTouchPair.angleInRadiansBetween - initialPair.angleInRadiansBetween)

    let panPassed: Bool = deltaTranslation > translationThreshold && deltaAngle < rotationThreshold
    let zoomPassed: Bool = deltaPinchDistance > distanceThreshold && deltaAngle < rotationThreshold
    let rotatePassed: Bool = deltaAngle > rotationThreshold
    
    if panPassed {
      self = .pan
    } else if zoomPassed {
      self = .zoom
    } else if rotatePassed {
      self = .rotate
    } else {
      self = .none
    }
  }

  private static func translationDistance(
    from initialPair: TouchPair,
    to currentPair: TouchPair,
  ) -> CGFloat {
    let midpointInitial: CGPoint = initialPair.midPointBetween
    let midpointCurrent: CGPoint = currentPair.midPointBetween

    let distance = midpointInitial.distance(to: midpointCurrent)
    return distance
  }
}


public struct RawGesture: Identifiable, Hashable, Sendable {
  public let id: UUID
  //  public let phase: TrackpadGesturePhase
  public let touches: [MappedTouchPoint]
}

public struct TrackpadGesture: Identifiable, Hashable, Sendable {
  public let id: UUID
  public let type: GestureType
  //  public let phase: TrackpadGesturePhase
  //  public let touches: [TouchPoint]

  public static let none = TrackpadGesture(
    id: UUID(),
    type: .none,
    //    phase: .none
  )
}
