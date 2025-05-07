//
//  Model+Config.swift
//  LilyPad
//
//  Created by Dave Coleman on 6/5/2025.
//

import Foundation
import Persistable

@Persistable
public struct StrokeConfiguration: Codable, Hashable {
  /// Both used in `StrokeEngine/shouldAddPoint`
  var minDistance: CGFloat = 2
  var minSpeedForDenseSampling: CGFloat = 10
  
  /// Used in `CanvasView`, within `handler.strokeHandler.engine.drawStroke()`
  var pointDensity: Int = 2
  
  /// Below are used in `StrokeWidthHandler/calculateStrokeWidth`
  var velocitySensitivity: CGFloat = 0.5
  var minWidth: CGFloat = 1.0
  var maxWidth: CGFloat = 100
  var maxThinningSpeed: CGFloat = 3.0
  
}
