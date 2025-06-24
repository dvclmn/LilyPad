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

  let mapStrategy: TrackpadMapStrategy
  let shouldShowIndicators: Bool
  let shouldShowOverlay: Bool
  let touchUpdates: TouchesModifierOutput

  public func body(content: Content) -> some View {
    GeometryReader { proxy in
      content
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
      }
    }  // END geo reader


  }
}
extension View {

  public func touches(
    mapStrategy: TrackpadMapStrategy,
    showIndicators: Bool = true,
    shouldShowOverlay: Bool = true,
    touchUpdates: @escaping TouchesModifierOutput
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        mapStrategy: mapStrategy,
        shouldShowIndicators: showIndicators,
        shouldShowOverlay: shouldShowOverlay,
        touchUpdates: touchUpdates
      )
    )
  }
}




struct TrackpadShapeGuide: View {
  private let rounding: CGFloat = 20

  let containerSize: CGSize
  let mappingStrategy: TrackpadMapStrategy
//  let trackpadSize: CGSize
  public var body: some View {

    ZStack(alignment: .topLeading) {
      /// This is full-bleed, full width and height
      Color.gray.opacity(0.02)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      /// This is the trackpad-sized cut-out
      RoundedRectangle(cornerRadius: rounding)
        .blendMode(.destinationOut)
        /// Trackpad width and height
        .overlay {
          /// This just handles the stroke around the trackpad cut-out
          RoundedRectangle(cornerRadius: rounding)
            .fill(.clear)
            .strokeBorder(.gray.opacity(0.06), style: .simple01)
        }
        .frame(
          width: mappingStrategy.size(for: containerSize).width,
          height: mappingStrategy.size(for: containerSize).height
        )
        .position(containerSize.midpoint)

    }
    .compositingGroup()
    .allowsHitTesting(false)

  }
}
