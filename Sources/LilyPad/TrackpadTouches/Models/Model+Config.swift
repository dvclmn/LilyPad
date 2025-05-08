//
//  Model+Config.swift
//  LilyPad
//
//  Created by Dave Coleman on 6/5/2025.
//

import Foundation
import Persistable
import MemberwiseInit

//@MemberwiseInit(.public)
@Persistable
public struct StrokeConfiguration: Hashable {
  /// Both used in `StrokeEngine/shouldAddPoint`
  public var minDistance: CGFloat = 2
  public var minSpeedForDenseSampling: CGFloat = 10
  
  /// Used in `CanvasView`, within `handler.strokeHandler.engine.drawStroke()`
  public var pointDensity: Int = 2
  
  /// Below are used in `StrokeWidthHandler/calculateStrokeWidth`
  public var velocitySensitivity: CGFloat = 0.5
  public var minStrokeWidth: CGFloat = 1.0
  public var maxStrokeWidth: CGFloat = 100
  public var maxThinningSpeed: CGFloat = 3.0
  public var curveType: CatmullRomType = .chordal
}
