//
//  Model+Artwork.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct Artwork: Codable, Equatable {
  //  public var canvasSize: CGSize = .zero
  public var canvasSize: CGSize = .init(width: 700, height: 438)
  public var completedStrokes: [TouchStroke] = []
  
  /// Still not sure about this — aim is that the Artwork can either be
  /// a) Unopinionated about the qualities/parameters of the stroke, so just the skeleton
  /// b) Carry with it a little 'preset', so if desired, the visual intent can also be expressed
  public var config: StrokeConfiguration? = nil
  
  public static let `default` = Artwork()
}
