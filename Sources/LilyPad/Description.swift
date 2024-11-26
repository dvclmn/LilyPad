//
//  Description.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import Foundation

extension TrackpadGestureState: @preconcurrency CustomStringConvertible {

  public var description: String {
    return """
    
    -----
    `scaleEffect`: \(scaleEffect)
    `rotationAngle`: \(rotationAngle)
    
    `magnificationDelta`: \(magnificationDelta)
    `totalMagnification`: \(totalMagnification)
    
    `rotationDelta`: \(rotationDelta)
    `totalRotation`: \(totalRotation)
    
    `scrollDeltaX`: \(scrollDeltaX)
    `scrollDeltaY`: \(scrollDeltaY)
    `totalTranslationX`: \(totalTranslationX)
    `totalTranslationY`: \(totalTranslationY)
    
    Phase: \(phase.name)
    
    -----
    
    """
  }
}
