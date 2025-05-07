//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI

public struct TrackpadTouchesModifier: ViewModifier {
  @State private var localTouches: Set<TouchPoint> = []
  let showIndicators: Bool
  let canvasSize: CGSize
  let touchUpdates: TouchUpdates

  public init(
    showIndicators: Bool,
    canvasSize: CGSize,
    touchUpdates: @escaping TouchUpdates
  ) {
    self.showIndicators = showIndicators
    self.canvasSize = canvasSize
    self.touchUpdates = touchUpdates
  }
  public func body(content: Content) -> some View {
    ZStack {
      content
      if showIndicators {
        TouchIndicatorsView(touches: localTouches, canvasSize: canvasSize)
          
      }
      TrackpadTouchesView { touches, pressure in
        self.localTouches = touches
        touchUpdates(touches, pressure)
        //        if let touchUpdates {
        //        }
      }
    }
  }
}
extension View {
  public func touches(
    showIndicators: Bool = true,
    canvasSize: CGSize,
    touchUpdates: @escaping TouchUpdates
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        showIndicators: showIndicators,
        canvasSize: canvasSize,
        touchUpdates: touchUpdates
      ))
  }
}

//public struct TouchesView<Content: View>: View {
//  @State private var touches: Set<TouchPoint> = []
//
//  public typealias Touches = (Set<TouchPoint>) -> Content
//
//  let showIndicators: Bool
//  let canvasSize: CGSize
//  let content: Touches
//
//  public init(
//    showIndicators: Bool = true,
//    canvasSize: CGSize,
//    @ViewBuilder content: @escaping Touches,
//  ) {
//    self.showIndicators = showIndicators
//    self.canvasSize = canvasSize
//    self.content = content
//  }
//
//  public var body: some View {
//
//    ZStack {
//      content(touches)
//      TouchIndicatorsView(touches: touches, canvasSize: canvasSize)
//      TrackpadTouchesView { touches, pressure in
//        self.touches = touches
//      }
//    }
//  }
//}
