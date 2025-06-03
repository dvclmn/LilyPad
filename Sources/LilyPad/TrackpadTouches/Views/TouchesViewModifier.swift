//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseComponents
import BaseHelpers
import SwiftUI

public typealias TouchesModifierOutput = (MappedTouchPoints) -> Void
//public typealias TouchesModifierOutput = (_ eventData: Set<TouchPoint>) -> Void

public struct TrackpadTouchesModifier: ViewModifier {

  @State private var localMappedTouches = MappedTouchPoints()
  //  @State private var localTouches: Set<TouchPoint> = []

  //  let isClickEnabled: Bool
  let shouldUseVelocity: Bool
  let shouldShowIndicators: Bool
  let mappingRect: CGRect
  let touchUpdates: TouchesModifierOutput

  public func body(content: Content) -> some View {
    GeometryReader { _ in
      ZStack(alignment: .topLeading) {
        content
//        if shouldShowIndicators {
//          TouchIndicatorsView(touches: localMappedTouches)
//        }
//
//        TrackpadShapeGuide(rect: mappingRect)
      }
      .drawingGroup()


      TrackpadTouchesView(shouldUseVelocity: shouldUseVelocity) { eventData in

        let touches: Set<TouchPoint>
        
        if isPreview {
          let exampleTouches: Set<TouchPoint> = [
            TouchPoint.example01,
            TouchPoint.example02,
            TouchPoint.topLeading,
            TouchPoint.topTrailing,
            TouchPoint.bottomLeading,
            TouchPoint.bottomTrailing,
          ]
          touches = exampleTouches

        } else {
          touches = eventData?.touches ?? []
        }
        
        guard mappingRect.size.isPositive else { return }

        let mappedTouches = MappedTouchPoints(
          touches: touches,
          mappedRect: mappingRect
        )

        self.localMappedTouches = mappedTouches
        touchUpdates(mappedTouches)
      }
      //      .background {
      //        Color.cyan.opacity(0.2)
      //        Text("AppKit touch tracking view")
      //          .foregroundStyle(.cyan)
      //          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
      //      }
    }  // END geo reader


  }
}
extension View {
  /// `mappingRect` should (I think) be the same as what constrains touches
  /// out in the view using the touches. Otherwise the indicators and the actual
  /// strokes/gestures won't line up.
  /// It's used in this modifier for the touch indicators only
  public func touches(
    //    isClickEnabled: Bool,
    shouldUseVelocity: Bool = true,
    showIndicators: Bool = true,
    mappedTo mappingRect: CGRect,
    touchUpdates: @escaping TouchesModifierOutput
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        //        isClickEnabled: isClickEnabled,
        shouldUseVelocity: shouldUseVelocity,
        shouldShowIndicators: showIndicators,
        mappingRect: mappingRect,
        touchUpdates: touchUpdates
      )
    )
  }
}


struct TrackpadShapeGuide: View {
  private let rounding: CGFloat = 20
  let rect: CGRect
  public var body: some View {

    ZStack(alignment: .topLeading) {
      /// This is full-bleed, full width and height
      Color.gray.opacity(0.05)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      /// This is the trackpad-sized cut-out
      RoundedRectangle(cornerRadius: rounding)
        .blendMode(.destinationOut)
        /// Trackpad width and height
        .overlay {
          /// This just handles the stroke around the trackpad cut-out
          RoundedRectangle(cornerRadius: rounding)
            .fill(.clear)
            .strokeBorder(.gray.opacity(0.08), style: .simple02)
        }
        .frame(
          width: rect.width,
          height: rect.height
        )
        .position(rect.origin)

    }
    .compositingGroup()
    .allowsHitTesting(false)

  }
}


public struct TouchesModifierExampleView: View {

  public var body: some View {

    GeometryReader { proxy in
      Text("Hello")
        .touches(
          shouldUseVelocity: true,
          showIndicators: true,
          mappedTo: mappingRect(proxy.size)
        ) { eventData in
          //
        }
    }
    .background(.black.secondary)

  }
}
extension TouchesModifierExampleView {
  func mappingRect(_ containerSize: CGSize) -> CGRect {
    let exampleSize: CGSize = .init(width: 400, height: 300)
    guard let rect: CGRect = exampleSize.toCGRect(centredIn: containerSize) else {
      return .zero
    }
    return rect
  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.normal)) {
  TouchesModifierExampleView()
}
#endif
