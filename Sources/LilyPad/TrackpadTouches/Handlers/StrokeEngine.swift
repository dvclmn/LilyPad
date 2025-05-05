//
//  Model+StrokeEngine.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation

public struct StrokeEngine {
  
  public var settings: StrokeSettings
  private var strokeWidth: StrokeWidthHandler
  
  public init(settings: StrokeSettings = .default) {
    self.settings = settings
    self.strokeWidth = StrokeWidthHandler(
      baseWidth: settings.baseStrokeWidth,
      sensitivity: settings.velocitySensitivity
    )
  }
  
  public func shouldAddPoint(
    from last: CGPoint,
    to current: CGPoint,
    speed: CGFloat
  ) -> Bool {
    let distance = hypot(current.x - last.x, current.y - last.y)
    return distance > settings.minDistance || speed < settings.minSpeedForSparseSampling
  }
  
  public func calculateWidth(for speed: CGFloat) -> CGFloat {
    strokeWidth.calculateStrokeWidth(for: speed)
  }
}


public struct StrokeSettings {
  public var baseStrokeWidth: CGFloat
  
  /// 0 = insensitive, 1 = full range
  public var velocitySensitivity: CGFloat
  
  /// Minimum Euclidean distance between sampled points
  public var minDistance: CGFloat
  
  /// Allow sparse samples if slow
  public var minSpeedForSparseSampling: CGFloat
  
  public static let `default` = StrokeSettings(
    baseStrokeWidth: 10,
    velocitySensitivity: 0.5,
    minDistance: 200,
    minSpeedForSparseSampling: 1.0
  )
}
