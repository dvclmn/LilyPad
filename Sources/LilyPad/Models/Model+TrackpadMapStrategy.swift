//
//  Model+TrackpadMapStrategy.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import Foundation

public enum TrackpadMapStrategy {
  case scaleToFit
  case scaleToFill
  case stretch
  case customWidth(CGFloat)
  
  private var aspectRatio: CGFloat {
    Self.trackpadAspectRatio
  }
  
  func size(for containerSize: CGSize) -> CGSize {
    switch self {
      case .scaleToFit:
        return CGSize(
          width: containerSize.width,
          height: containerSize.width * aspectRatio
        )
      case .scaleToFill:
        <#code#>
      case .stretch:
        <#code#>
      case .customWidth(let width):
        <#code#>
    }
  }
}

extension TrackpadMapStrategy {
  public static let trackpadAspectRatio: CGFloat = 10.0 / 16.0
  public static var trackpadSize: CGSize {
    let width: CGFloat = 700
    let height: CGFloat = width * trackpadAspectRatio
    return CGSize(width: width, height: height)
  }
  
//  public static generateSize
}
