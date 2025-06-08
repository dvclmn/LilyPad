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

public struct TrackpadTouchesModifier: ViewModifier {
  @State private var localMappedTouches: [MappedTouchPoint] = []

//  let shouldUseVelocity: Bool
  let shouldShowIndicators: Bool
  let mappingRect: CGRect
  let touchUpdates: TouchesModifierOutput

  public func body(content: Content) -> some View {
    GeometryReader { proxy in
      ZStack(alignment: .topLeading) {
        content
        if shouldShowIndicators {
          TouchIndicatorsView(
            touches: localMappedTouches,
            mappingRect: mappingRect,
            containerSize: proxy.size,
          )
        }
        //
        TrackpadShapeGuide(
          containerSize: proxy.size,
          rect: mappingRect
        )
      }
      .drawingGroup()

      TrackpadTouchesView(
        shouldUseVelocity: true
      ) { eventData in

        let touches = eventData?.touches ?? []
        guard mappingRect.size.isPositive else { return }

        let mappedTouchBuilder = MappedTouchPointsBuilder(
          touches: touches,
          mappingRect: mappingRect
        )
        let mapped = mappedTouchBuilder.mappedTouches

        self.localMappedTouches = mapped
        touchUpdates(mapped)
      }
//      .allowsHitTesting(false)
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
//    shouldUseVelocity: Bool = true,
    showIndicators: Bool = true,
    mappedTo mappingRect: CGRect,
    touchUpdates: @escaping TouchesModifierOutput
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        //        isClickEnabled: isClickEnabled,
//        shouldUseVelocity: shouldUseVelocity,
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
      //        .position(rect.origin)

    }
    .compositingGroup()
    .allowsHitTesting(false)

  }
}


//public struct TouchesModifierExampleView: View {
//
//  public var body: some View {
//
//    GeometryReader { proxy in
//      Text("Hello")
//        .touches(
//          shouldUseVelocity: true,
//          showIndicators: true,
//          mappedTo: mappingRect(proxy.size)
//        ) { eventData in
//          //
//        }
//    }
//    .background(.black.secondary)
//
//  }
//}
//extension TouchesModifierExampleView {
//  func mappingRect(_ containerSize: CGSize) -> CGRect {
//    let exampleSize: CGSize = .init(width: 400, height: 300)
//    let rect: CGRect = exampleSize.toCGRect(in: containerSize)
//    return rect
//  }
//}
//#if DEBUG
//@available(macOS 15, iOS 18, *)
//#Preview(traits: .size(.normal)) {
//  TouchesModifierExampleView()
//}
//#endif
