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
    lastTouchPair: TouchPair
  ) {
    
    /// Movement across the screen. Used to detect panning
    let touchTranslationThreshold: CGFloat = 10
    
    /// Distance between fingers. Are we zooming?
    let touchDistanceThreshold: CGFloat = 10
    
    /// Change in rotation of line drawn between fingers
    let touchRotationThreshold: CGFloat = .pi / 30
    
    let deltaPan = currentTouchPair.midPointBetween - lastTouchPair.midPointBetween
    let deltaZoom = abs(currentTouchPair.distanceBetween - lastTouchPair.distanceBetween)
    let deltaAngle = abs(currentTouchPair.angleInRadiansBetween - lastTouchPair.angleInRadiansBetween)
    
    let zoomPassed = deltaZoom > zoomThreshold
    let rotatePassed = deltaAngle > rotationThreshold
    let panPassed = deltaPan.length > panThreshold
    
    
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

