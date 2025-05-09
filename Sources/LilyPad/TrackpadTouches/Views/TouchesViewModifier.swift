//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseHelpers
import SwiftUI

public struct TrackpadTouchesModifier: ViewModifier {
  @State private var localTouches: Set<TouchPoint> = []

  let showIndicators: Bool
  let touchUpdates: TouchUpdates

  public func body(content: Content) -> some View {
    GeometryReader { proxy in
      content
      if showIndicators {
        TouchIndicatorsView(
          touches: localTouches,
          mappingRect: proxy.size.toCGRect
        )
      }
      TrackpadTouchesView { eventData in
        self.localTouches = eventData.touches
        touchUpdates(eventData)
      }
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
      )
    )
  }
}
