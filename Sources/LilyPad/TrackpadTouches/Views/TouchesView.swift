//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI
import BaseHelpers

public struct TrackpadTouchesModifier: ViewModifier {
  @State private var viewSize: CGSize = .zero
  @State private var localTouches: Set<TouchPoint> = []
  
  let showIndicators: Bool
  let touchUpdates: TouchUpdates

  public init(
    showIndicators: Bool,
    touchUpdates: @escaping TouchUpdates
  ) {
    self.showIndicators = showIndicators
    self.touchUpdates = touchUpdates
  }
  public func body(content: Content) -> some View {
    ZStack {
      content
      if showIndicators {
        TouchIndicatorsView(
          touches: localTouches,
          mappingRect: viewSize
        )
      }
      TrackpadTouchesView { events in
        self.localTouches = events.touches
        touchUpdates(events)
      }
    }
    .viewSize { size in
      self.viewSize = size
    }
  }
}
extension View {
  public func touches(
    showIndicators: Bool = true,
    touchUpdates: @escaping TouchUpdates
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        showIndicators: showIndicators,
        touchUpdates: touchUpdates
      ))
  }
}
