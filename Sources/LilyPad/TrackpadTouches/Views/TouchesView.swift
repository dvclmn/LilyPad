//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI

public struct TrackpadTouchesModifier: ViewModifier {
  @State private var localTouches: Set<TouchPoint> = []
  let showIndicators: Bool
  let mapToSize: CGSize
  let touchUpdates: TouchUpdates

  public init(
    showIndicators: Bool,
    mapToSize: CGSize,
    touchUpdates: @escaping TouchUpdates
  ) {
    self.showIndicators = showIndicators
    self.mapToSize = mapToSize
    self.touchUpdates = touchUpdates
  }
  public func body(content: Content) -> some View {
    ZStack {
      content
      if showIndicators {
        TouchIndicatorsView(
          touches: localTouches,
          mapToSize: mapToSize
        )
      }
      TrackpadTouchesView { touches, pressure in
        self.localTouches = touches
        touchUpdates(touches, pressure)
      }
    }
  }
}
extension View {
  public func touches(
    showIndicators: Bool = true,
    isMapped: Bool = false,
    canvasSize: CGSize,
    touchUpdates: @escaping TouchUpdates
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        showIndicators: showIndicators,
        mapToSize: mapToSize,
        touchUpdates: touchUpdates
      ))
  }
}
