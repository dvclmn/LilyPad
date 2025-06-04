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

    print("Let's determine/initialise gesture type, from a current pair and initial pair, of TouchPoints.")

    print("Current Pair: \(currentTouchPair)")
    print("Initial Pair: \(initialPair)")

    /// Movement across the screen. Used to detect panning
    let translationThreshold: CGFloat = 4

    /// Distance between fingers. Are we zooming?
    let distanceThreshold: CGFloat = 6

    /// Change in rotation of line drawn between fingers
    /// Experiment with values between `π/12 (~15°)` and `π/8 (~22.5°)`
//    let rotationThreshold: CGFloat = .pi / 30
    let rotationThreshold: CGFloat = .pi / 6  // ≈ 18 degrees


    let deltaTranslation: CGFloat = Self.translationDistance(
      from: initialPair,
      to: currentTouchPair
    )
    print("Translation Delta: \(deltaTranslation.displayString)")

    let deltaPinchDistance: CGFloat = abs(currentTouchPair.distanceBetween - initialPair.distanceBetween)
    print("Pinch-Distance Delta: \(deltaPinchDistance.displayString)")

    //    let deltaAngle: CGFloat = abs(currentTouchPair.angleInRadiansBetween - initialPair.angleInRadiansBetween)

    let currentAngleBetween = currentTouchPair.angleInRadiansBetween
    let initialAngleBetween = initialPair.angleInRadiansBetween

    let deltaAngle = abs(currentAngleBetween - initialAngleBetween)
    let adjustedDelta = min(deltaAngle, 2 * .pi - deltaAngle)
    let finalAngleDelta = deltaAngle

    print(
      """
      
      /// Angles ///
      Current Pair Angle Between: \(currentAngleBetween.displayString)
      Initial Pair Angle Between: \(initialAngleBetween.displayString)
      Angle Delta: \(deltaAngle.displayString)
      Angle *Adjusted* Delta: \(adjustedDelta.displayString)
      // END Angles ///
      
      """)


    let panPassed: Bool = deltaTranslation > translationThreshold && finalAngleDelta < rotationThreshold
    let zoomPassed: Bool = deltaPinchDistance > distanceThreshold && finalAngleDelta < rotationThreshold
    let rotatePassed: Bool = finalAngleDelta > rotationThreshold

//    if rotatePassed {
//      self = .rotate
//    } else if zoomPassed {
//      self = .zoom
//    } else if panPassed {
//      self = .pan
//    } else {
//      self = .none
//    }
    
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

enum GestureError: Error, LocalizedError {
  case touchesNotEqualToTwo
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
