//
//  Model+TrackpadMapStrategy.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUICore

//public enum CustomMapStrategy {
//
//  /// Respect trackpad aspect ratio, scale to fixed width
//  case width(CGFloat)
//
//  /// Respect trackpad aspect ratio, scale to fixed height
//  case height(CGFloat)
//}

public enum TrackpadMapStrategy {

  /// Fit trackpad within container width and height.
  /// Respects trackpad aspect ratio
  case scaleToFit

  /// Fill container with trackpad
  /// Respects trackpad aspect ratio.
  case scaleToFill

  /// Ignore trackpad aspect ratio, stretch
  /// to fill entirety of supplied container size
  case stretch

  case customFixed(CGFloat, axis: Axis)
  //  case custom(CustomMapStrategy)

  private var aspectRatio: CGFloat {
    Self.trackpadAspectRatio
  }

  public func size(for containerSize: CGSize) -> CGSize {
    switch self {
      case .scaleToFit:
        let widthBased = CGSize(
          width: containerSize.width,
          height: containerSize.width * aspectRatio
        )

        guard widthBased.height <= containerSize.height else {
          return CGSize(
            width: containerSize.height / aspectRatio,
            height: containerSize.height
          )
        }
        return widthBased

      case .scaleToFill:
        let containerRatio = containerSize.height / containerSize.width
        guard containerRatio > aspectRatio else {
          /// Container is wider than trackpad → match width
          return CGSize(
            width: containerSize.width,
            height: containerSize.width * aspectRatio
          )
        }
        /// Container is taller than trackpad → match height
        return CGSize(
          width: containerSize.height / aspectRatio,
          height: containerSize.height
        )

      case .stretch:
        return containerSize

      case .customFixed(let length, let axis):
        switch axis {
          case .horizontal:
            let width = length
            let height = length * aspectRatio
            return CGSize(width: width, height: height)
          case .vertical:
            let height = length
            let width = length / aspectRatio
            return CGSize(width: width, height: height)
        }
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
