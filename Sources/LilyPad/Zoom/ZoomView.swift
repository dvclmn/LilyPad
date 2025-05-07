//
//  ZoomView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseHelpers
import BaseStyles
import SwiftUI

public struct ZoomView<Content: View>: View {

  @State private var store = ZoomHandler()

  @State private var firstPositionPair: TouchPositions?
  @State private var currentPositionPair: TouchPositions?

  let scaleThresholdDistance: CGFloat = 10

  let canvasSize: CGSize
  let touchUpdates: TouchUpdates
  let content: Content

  public init(
    canvasSize: CGSize,
    touchUpdates: @escaping TouchUpdates,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.canvasSize = canvasSize
    self.touchUpdates = touchUpdates
    self.content = content()
  }

  public var body: some View {

    /// Using `GeometryReader` to kind 'reset' everything to be full width,
    /// full height, and top leading.
    GeometryReader { proxy in

      content
        //      Rectangle()
        //        .fill(.white.opacity(0.1))
        .midpointIndicator()
        .frame(width: store.canvasSize.width, height: store.canvasSize.height)
        .position(store.canvasPosition)
        .scaleEffect(store.scale)
        .drawingGroup()
        .task(id: proxy.size) {
          store.viewportSize = proxy.size
        }
    }
    .midpointIndicator()
    .mouseLock(store.touches.count == 2)
    .touches(mapToSize: store.viewportSize) { touches, pressure in
      if touches.count == 2 {
        panAmount(touches: touches)
      }
      store.touches = touches

      /// Pass the touches through to the recieving view
      touchUpdates(touches, pressure)

    }
    .toolbar {
      HStack {
        LabeledContent("Viewport", value: store.viewportSize.displayString(decimalPlaces: 0))
        Divider()
        LabeledContent("Pan", value: store.offset.displayString(style: .full))
      }
      .foregroundStyle(.tertiary)
      .font(.callout)
      .monospacedDigit()
      Button {
        store.offset = .zero
      } label: {
        Label("Reset pan", systemImage: "hand.draw")
      }
    }
    .task(id: canvasSize) {
      store.canvasSize = canvasSize
    }
  }
}
extension ZoomView {

  //  func roughPan(touches: Set<TouchPoint>) {
  //    let newPositions = TouchPositions(touches: touches)
  //    initialisePositionsIfNeeded(newPositions)
  //
  //
  //
  //  }

  func panAmount(touches: Set<TouchPoint>) {
    guard touches.count == 2 else {
      return
    }

    let newPositionPair = TouchPositions.mapped(from: touches, to: store.viewportSize.toCGRect)
//    let newPositionPair = TouchPositions(touches: touches, destinationRect: store.viewportSize.toCGRect)

    if firstPositionPair == nil {
      firstPositionPair = newPositionPair
    }
    currentPositionPair = newPositionPair


    if let firstPair = firstPositionPair, let currentPair = currentPositionPair {

      let delta = currentPair.midPoint - firstPair.midPoint
      let scale = currentPair.distanceBetween / firstPair.distanceBetween
      
//      print("first")

      store.offset = delta
      store.scale = scale
    }
  }
}

#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.narrow)) {
  ZoomView(canvasSize: CGSize.init(width: 400, height: 300)) { touches, pressure in
    //
  } content: {
    Text(TestStrings.paragraphs[5])
      .padding(40)
      .background(.purple.quinary)
      .frame(width: 400)

  }
  .frame(width: 600, height: 700)
  .background(.black.opacity(0.6))
}
#endif
