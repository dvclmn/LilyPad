//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseComponents
import BaseHelpers
import SwiftUI

public typealias TouchesModifierOutput = ([MappedTouchPoint]) -> Void

extension TrackpadTouchesView {
  public static let trackpadAspectRatio: CGFloat = 10.0 / 16.0
  public static var trackpadRect: CGRect {
    let width: CGFloat = 700
    let height: CGFloat = width * trackpadAspectRatio
    return CGRect(x: 0, y: 0, width: width, height: height)
  }
}

public struct TrackpadTouchesModifier: ViewModifier {
  @State private var localMappedTouches: [MappedTouchPoint] = []

  let shouldShowIndicators: Bool
//  let mappingRect: CGRect
  let touchUpdates: TouchesModifierOutput

  public func body(content: Content) -> some View {
    GeometryReader { proxy in
      ZStack(alignment: .topLeading) {
        content
        if shouldShowIndicators {
          TouchIndicatorsView(
            touches: localMappedTouches,
            mappingRect: TrackpadTouchesView.trackpadRect,
            containerSize: proxy.size,
          )
        }
        //
        TrackpadShapeGuide(
          containerSize: proxy.size,
          rect: TrackpadTouchesView.trackpadRect
        )
      }
      .drawingGroup()

      TrackpadTouchesView(
        shouldUseVelocity: true
      ) { eventData in

        let touches = eventData?.touches ?? []
        
        /// Handle touches for local views
        guard mappingRect.size.isPositive else { return }

        let mappedTouchBuilder = MappedTouchPointsBuilder(
          touches: touches,
          in: mappingRect
        )
        let mapped = mappedTouchBuilder.mappedTouches

        self.localMappedTouches = mapped
        
        /// Handle touches for View using the modifier
        touchUpdates(mapped)
      }
    }  // END geo reader


  }
}
extension View {
  /// `mappingRect` should (I think) be the same as what constrains touches
  /// out in the view using the touches. Otherwise the indicators and the actual
  /// strokes/gestures won't line up.
  /// It's used in this modifier for the touch indicators only
  public func touches(
    showIndicators: Bool = true,
    mappedTo mappingRect: CGRect,
    touchUpdates: @escaping TouchesModifierOutput
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        shouldShowIndicators: showIndicators,
        mappingRect: mappingRect,
        touchUpdates: touchUpdates
      )
    )
  }
}


struct TrackpadShapeGuide: View {
  private let rounding: CGFloat = 20

  let containerSize: CGSize
  let rect: CGRect
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
          width: rect.width,
          height: rect.height
        )
        .position(containerSize.centrePoint)

    }
    .compositingGroup()
    .allowsHitTesting(false)

  }
}
