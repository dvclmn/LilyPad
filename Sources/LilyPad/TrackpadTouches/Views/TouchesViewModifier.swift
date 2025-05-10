//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseHelpers
import SwiftUI

public typealias TouchesModifierOutput = (_ eventData: TouchEventData) -> Void

public struct TrackpadTouchesModifier: ViewModifier {
  @State private var localTouches: Set<TouchPoint> = []

  let showIndicators: Bool
  let viewSize: CGSize
  let touchUpdates: TouchesModifierOutput

  public func body(content: Content) -> some View {
    GeometryReader { _ in
      content
      if showIndicators {
        TouchIndicatorsView(
          touches: localTouches.array,
          mappingRect: viewSize.toCGRect
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
    in viewSize: CGSize,
    touchUpdates: @escaping TouchesModifierOutput
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        showIndicators: showIndicators,
        viewSize: viewSize,
        touchUpdates: touchUpdates
      )
    )
  }
}
