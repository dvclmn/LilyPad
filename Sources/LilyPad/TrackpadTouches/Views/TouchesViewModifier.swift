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

  let isClickEnabled: Bool
  let shouldUseVelocity: Bool
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

      TrackpadTouchesView(
        isClickEnabled: isClickEnabled,
        shouldUseVelocity: shouldUseVelocity
      ) { eventData in
        /// It's ok to fall back here to `[]`, as the touch indicators `ForEach`
        /// should gracefully handle displaying *nothing*, if there is an empty set
        //        guard let eventData else {
        //          self.localTouches = []
        //          touchUpdates(nil)
        //          return
        //        }
        //        print("`TrackpadTouchesModifier`: Number of touches: \(eventData?.touches.count ?? 0). Phase: \(eventData?.phase.rawValue ?? "—")")
        //        print("Touches received on the SwiftUI end: `\(eventData?.description ?? "nil")`")
        self.localTouches = eventData?.getTouches(mappedTo: mappingRect) ?? []
        touchUpdates(eventData)
      }

    }
    //    .task(id: isClickEnabled) {
    //      print("`TrackpadTouchesModifier`'s Is Click Enabled changed. Value is: `\(isClickEnabled)`")
    //    }
  }
}
extension View {
  /// `mappingRect` should (I think) be the same as what constrains touches
  /// out in the view using the touches. Otherwise the indicators and the actual
  /// strokes/gestures won't line up.
  /// It's used in this modifier for the touch indicators only
  public func touches(
    isClickEnabled: Bool,
    shouldUseVelocity: Bool = true,
    showIndicators: Bool = true,
    in mappingRect: CGRect,
    touchUpdates: @escaping TouchesModifierOutput
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        isClickEnabled: isClickEnabled,
        shouldUseVelocity: shouldUseVelocity,
        showIndicators: showIndicators,
        mappingRect: mappingRect,
        touchUpdates: touchUpdates
      )
    )
  }
}
