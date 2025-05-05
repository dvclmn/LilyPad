//
//  StrokeSettings.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation

public struct StrokeSettings {
  public var baseStrokeWidth: CGFloat
  
  /// 0 = insensitive, 1 = full range
  public var velocitySensitivity: CGFloat
  
  /// Minimum Euclidean distance between sampled points
  public var minDistance: CGFloat
  
  /// Allow sparse samples if slow
  public var minSpeedForSparseSampling: CGFloat
  
  public var splineResolution: Int
  
  public init(
    baseStrokeWidth: CGFloat,
    velocitySensitivity: CGFloat,
    minDistance: CGFloat,
    minSpeedForSparseSampling: CGFloat,
    splineResolution: Int
  ) {
    print("`StrokeSettings` created at \(Date.now.format(.timeDetailed))")
    self.baseStrokeWidth = baseStrokeWidth
    self.velocitySensitivity = velocitySensitivity
    self.minDistance = minDistance
    self.minSpeedForSparseSampling = minSpeedForSparseSampling
    self.splineResolution = splineResolution
  }
  
  public static let `default` = StrokeSettings(
    baseStrokeWidth: 10,
    velocitySensitivity: 0.5,
    minDistance: 20,
    minSpeedForSparseSampling: 1.0,
    splineResolution: 8
  )
}
