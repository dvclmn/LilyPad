//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseComponents
import BaseHelpers
import SwiftUI

public struct MappedTouchPoints {
  private let touches: Set<TouchPoint>
  let mappedRect: CGRect

  public init(
    touches: Set<TouchPoint> = [],
    mappedRect: CGRect = .zero
  ) {
    self.touches = touches
    self.mappedRect = mappedRect
  }

  public var touchCount: Int {
    self.touches.count
  }


  public var mappedTouches: [MappedTouchPoint] {
    let allMapped: [MappedTouchPoint] = touches.map { touchPoint in
      let position = touchPoint.position.mapped(to: mappedRect)
      let newTouchPoint = touchPoint.withUpdatedPosition(position)
      return MappedTouchPoint(touchPoint: newTouchPoint)
    }
    return allMapped
  }

  public var mappedTouchPoints: [TouchPoint] {
    let mapped = mappedTouches.map(\.touchPoint)
    //    let allMapped: [MappedTouchPoint] = touches.map { touchPoint in
    //      let position = touchPoint.position.mapped(to: mappedRect)
    //      let newTouchPoint = touchPoint.withUpdatedPosition(position)
    //      return MappedTouchPoint(touchPoint: newTouchPoint)
    //    }
    return mapped
  }

  public func mappedTouch(withID id: TouchPoint.ID) -> MappedTouchPoint? {
    guard let touch = touches.first(where: { $0.id == id }) else {
      print("Couldn't find TouchPoint matching id: \(id)")
      return nil
    }
    let newPosition: CGPoint = touch.position.mapped(to: mappedRect)
    let newTouchPoint = touch.withUpdatedPosition(newPosition)

    return MappedTouchPoint(
      touchPoint: newTouchPoint
    )
  }
}

public struct MappedTouchPoint {
  public let touchPoint: TouchPoint
}

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
      content
      if shouldShowIndicators {
        TouchIndicatorsView(touches: localMappedTouches)
      }

      TrackpadTouchesView(shouldUseVelocity: shouldUseVelocity) { eventData in

        let touches = eventData?.touches ?? []

        let mappedTouches = MappedTouchPoints(
          touches: touches,
          mappedRect: mappingRect
        )

        self.localMappedTouches = mappedTouches
        touchUpdates(mappedTouches)
      }

      TrackpadShapeGuide(rect: mappingRect)
    }
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
