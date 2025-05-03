//
//  Models.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI

/// Represents a normalized touch on the trackpad
public struct TrackpadTouch: Identifiable, Hashable {
  public let id: Int
  public let position: CGPoint
  public let timestamp: TimeInterval
  public let pressure: CGFloat
  
  public init(_ nsTouch: NSTouch) {
    self.id = nsTouch.identity.hash
    self.position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      /// Flip Y to match SwiftUI coordinate system
      y: 1.0 - nsTouch.normalizedPosition.y
    )
    self.timestamp = Date().timeIntervalSince1970
//    self.timestamp = ProcessInfo.processInfo.systemUptime
    self.pressure = 1.0
  }
}
