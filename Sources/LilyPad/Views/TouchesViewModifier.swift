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

extension TrackpadTouchesView {
  public static let trackpadAspectRatio: CGFloat = 10.0 / 16.0
  public static var trackpadSize: CGSize {
    let width: CGFloat = 700
    let height: CGFloat = width * trackpadAspectRatio
    return CGSize(width: width, height: height)
  }
}

public struct TrackpadTouchesModifier: ViewModifier {
  @State private var localMappedTouches: [MappedTouchPoint] = []

  let shouldShowIndicators: Bool
  let touchUpdates: TouchesModifierOutput

  public func body(content: Content) -> some View {
    GeometryReader { proxy in
      ZStack(alignment: .topLeading) {
        content
        if shouldShowIndicators {
          TouchIndicatorsView(
            touches: localMappedTouches,
            mappingSize: TrackpadTouchesView.trackpadSize,
            containerSize: proxy.size,
          )
        }
        //
        TrackpadShapeGuide(
          containerSize: proxy.size,
          trackpadSize: TrackpadTouchesView.trackpadSize
        )
      }
      .drawingGroup()

      TrackpadTouchesView(
        shouldUseVelocity: true
      ) { eventData in

        let touches = eventData?.touches ?? []

        if shouldShowIndicators {
          /// Handle touches for local views
          let mappedTouchBuilder = MappedTouchPointsBuilder(
            touches: touches,
            in: TrackpadTouchesView.trackpadSize
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
    showIndicators: Bool = true,
    touchUpdates: @escaping TouchesModifierOutput
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        shouldShowIndicators: showIndicators,
        touchUpdates: touchUpdates
      )
    )
  }
}


struct TrackpadShapeGuide: View {
  private let rounding: CGFloat = 20

  let containerSize: CGSize
  let trackpadSize: CGSize
  public var body: some View {

    ZStack(alignment: .topLeading) {
      /// This is full-bleed, full width and height
      Color.gray.opacity(0.08)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      /// This is the trackpad-sized cut-out
      RoundedRectangle(cornerRadius: rounding)
        .blendMode(.destinationOut)
        /// Trackpad width and height
        .overlay {
          /// This just handles the stroke around the trackpad cut-out
          RoundedRectangle(cornerRadius: rounding)
            .fill(.clear)
            .strokeBorder(.gray.opacity(0.1), style: .simple02)
        }
        .frame(
          width: trackpadSize.width,
          height: trackpadSize.height
        )
        .position(containerSize.centrePoint)

    }
    .compositingGroup()
    .allowsHitTesting(false)

  }
}
