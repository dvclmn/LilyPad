//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseHelpers
import SwiftUI

public typealias TouchesModifierOutput = (_ eventData: TouchEventData?) -> Void

public struct TrackpadTouchesModifier: ViewModifier {
  @State private var localTouches: Set<TouchPoint> = []

  let showIndicators: Bool
  let mappingRect: CGRect
  let touchUpdates: TouchesModifierOutput

  public func body(content: Content) -> some View {
    GeometryReader { _ in
      content
      if showIndicators {
        TouchIndicatorsView(
          touches: localTouches,
          mappingRect: mappingRect
        )
      }
      TrackpadTouchesView { eventData in
        /// It's ok to fall back here to `[]`, as the touch indicators `ForEach`
        /// should gracefully handle displaying *nothing*, if there is an empty set
//        guard let eventData else {
//          self.localTouches = []
//          touchUpdates(nil)
//          return
//        }
        self.localTouches = eventData?.touches ?? []
        touchUpdates(eventData)
      }
    }
  }
}
extension View {
  public func touches(
    showIndicators: Bool = true,
    in mappingRect: CGRect,
    touchUpdates: @escaping TouchesModifierOutput
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        showIndicators: showIndicators,
        mappingRect: mappingRect,
        touchUpdates: touchUpdates
      )
    )
  }
}
