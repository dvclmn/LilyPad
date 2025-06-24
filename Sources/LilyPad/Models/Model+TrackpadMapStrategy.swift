//
//  Model+TrackpadMapStrategy.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import Foundation

public enum CustomMapStrategy {

  /// Respect trackpad aspect ratio, scale to fixed width
  case width(CGFloat)
  
  /// Respect trackpad aspect ratio, scale to fixed height
  case height(CGFloat)
}

public enum TrackpadMapStrategy {
  
  /// Fit trackpad within container width and height.
  /// Respects trackpad aspect ratio
  case scaleToFit(CGSize)
  
  /// Fill container with trackpad
  /// Respects trackpad aspect ratio.
  case scaleToFill(CGSize)
  
  /// Ignore trackpad aspect ratio, stretch
  /// to fill entirety of supplied container size
  case stretch(CGSize)
  
  case custom(CustomMapStrategy)
  
  private var aspectRatio: CGFloat {
    Self.trackpadAspectRatio
  }
  
  func size(for containerSize: CGSize) -> CGSize {
    switch self {
      case .scaleToFit:
        let widthBased = CGSize(
          width: containerSize.width,
          height: containerSize.width * aspectRatio
        )
        
        if widthBased.height <= containerSize.height {
          return widthBased
        } else {
          return CGSize(
            width: containerSize.height / aspectRatio,
            height: containerSize.height
          )
        }
//        return CGSize(
//          width: containerSize.width,
//          height: containerSize.width * aspectRatio
//        )
        
      case .scaleToFill:
        let containerRatio = containerSize.height / containerSize.width
        if containerRatio > aspectRatio {
          // Container is taller than trackpad → match height
          return CGSize(
            width: containerSize.height / aspectRatio,
            height: containerSize.height
          )
        } else {
          // Container is wider than trackpad → match width
          return CGSize(
            width: containerSize.width,
            height: containerSize.width * aspectRatio
          )
        }
        
      case .stretch:
        return containerSize
        
//      case .customWidth(let width):
//        return CGSize(
//          width: width,
//          height: width * aspectRatio
//        )
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
