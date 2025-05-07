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
  let canvasSize: CGSize
  let touchUpdates: TouchUpdates

  public init(
    showIndicators: Bool,
    canvasSize: CGSize,
    touchUpdates: @escaping TouchUpdates
  ) {
    self.showIndicators = showIndicators
    self.canvasSize = canvasSize
    self.touchUpdates = touchUpdates
  }
  public func body(content: Content) -> some View {
    ZStack {
      content
      if showIndicators {
        TouchIndicatorsView(touches: localTouches, canvasSize: canvasSize)
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
    canvasSize: CGSize,
    touchUpdates: @escaping TouchUpdates
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        showIndicators: showIndicators,
        canvasSize: canvasSize,
        touchUpdates: touchUpdates
      ))
  }
}
