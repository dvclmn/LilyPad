//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseComponents
import BaseHelpers
import SwiftUI

public typealias TouchesModifierOutput = (Set<TouchPoint>) -> Void

public struct TrackpadTouchesModifier: ViewModifier {

  @State private var localMappedTouches: Set<MappedTouchPoint> = []

  let isEnabled: Bool
  let mapStrategy: TrackpadMapStrategy
  let shouldShowIndicators: Bool
  let shouldShowOverlay: Bool
  let touchUpdates: TouchesModifierOutput

  public func body(content: Content) -> some View {
    GeometryReader { proxy in
      content
      if isEnabled {
        if shouldShowIndicators {
          TouchIndicatorsView(
            touches: localMappedTouches.toArray,
            mappingStrategy: mapStrategy,
            //          mappingSize: TrackpadTouchesView.trackpadSize,
            containerSize: proxy.size,
          )
        }
        if shouldShowOverlay {
          TrackpadShapeGuide(
            containerSize: proxy.size,
            mappingStrategy: mapStrategy
          )
        }
        TrackpadTouchesView(
          shouldUseVelocity: true
        ) { eventData in

          let touches = eventData?.touches ?? []

          if shouldShowIndicators {
            /// Handle touches for local views
            let mappedTouchBuilder = MappedTouchPointsBuilder(
              touches: touches,
              in: mapStrategy.size(for: proxy.size)
            )
            let mapped = mappedTouchBuilder.mappedTouches
            self.localMappedTouches = mapped
          }

          /// Handle touches for View using the modifier
          touchUpdates(touches)
        }  // touches view
      }  // END isEnabled check
    }  // END geo reader
  }
}
extension View {

  public func touches(
    isEnabled: Bool = true,
    mapStrategy: TrackpadMapStrategy,
    showIndicators: Bool = true,
    shouldShowOverlay: Bool = true,
    touchUpdates: @escaping TouchesModifierOutput
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        isEnabled: isEnabled,
        mapStrategy: mapStrategy,
        shouldShowIndicators: showIndicators,
        shouldShowOverlay: shouldShowOverlay,
        touchUpdates: touchUpdates
      )
    )
  }
}
