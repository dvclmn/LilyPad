//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseHelpers
import SwiftUI

public typealias TouchesModifierOutput = (_ eventData: Set<TouchPoint>) -> Void

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
        
        let touches = eventData?.getTouches(mappedTo: mappingRect) ?? []
        
        self.localTouches = touches
        touchUpdates(touches)
      }
    }
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
