//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI
import BaseHelpers

public struct TrackpadTouchesModifier: ViewModifier {
  @State private var localTouches: Set<TouchPoint> = []
  
  let showIndicators: Bool
  let viewSize: CGSize
  let touchUpdates: TouchUpdates

  public func body(content: Content) -> some View {
    ZStack {
      content
      if showIndicators {
        TouchIndicatorsView(
          touches: localTouches,
          mappingRect: viewSize.toCGRect
        )
      }
      TrackpadTouchesView { events in
        self.localTouches = events.touches
        touchUpdates(events)
      }
    }
    
  }
}
extension View {
  public func touches(
    showIndicators: Bool = true,
    viewSize: CGSize,
    touchUpdates: @escaping TouchUpdates
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        showIndicators: showIndicators,
        viewSize: viewSize,
        touchUpdates: touchUpdates
      ))
  }
}
