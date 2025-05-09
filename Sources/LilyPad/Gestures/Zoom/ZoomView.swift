//
//  ZoomView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseHelpers
import BaseStyles
import SwiftUI

//public struct ZoomView<Content: View>: View {
//
//  public typealias EventOutput = (TouchEventData) -> Void
//  @State private var store = ZoomHandler()
//
//  private let zoomThreshold: CGFloat = 40
//  private let scaleThresholdDistance: CGFloat = 10
//
//  let shouldLockMouse: Bool
//  let showIndicators: Bool
//  let canvasSize: CGSize
//  let didUpdateEventData: EventOutput
//  let content: Content
//
//  public init(
//    shouldLockMouse: Bool = false,
//    showIndicators: Bool = true,
//    canvasSize: CGSize,
//    didUpdateEventData: @escaping EventOutput,
//    @ViewBuilder content: @escaping () -> Content
//  ) {
//    self.shouldLockMouse = shouldLockMouse
//    self.showIndicators = showIndicators
//    self.canvasSize = canvasSize
//    self.didUpdateEventData = didUpdateEventData
//    self.content = content()
//
//    print("`ZoomView<Content: View>` created at \(Date.now.format(.timeDetailed))")
//  }
//
//  public var body: some View {
//
//    @Bindable var store = store
//
//    /// Using `GeometryReader` to kind 'reset' everything to be full width,
//    /// full height, and top leading.
//    GeometryReader { proxy in
//      content
//        .midpointIndicator()
//        .frame(width: store.canvasSize.width, height: store.canvasSize.height)
//        .scaleEffect(store.gestureState.zoom)
//        .position(store.canvasPosition)
//        .drawingGroup()
//        .task(id: proxy.size) {
//          store.viewportSize = proxy.size
//        }
//    }
//    .midpointIndicator()
//    .mouseLock(shouldLockMouse)
//
//    .touches(
//      showIndicators: showIndicators,
//      viewSize: store.viewportSize
//    ) { eventData in
//      handleEventData(eventData)
//    }
//    .toolbar {
//      ZoomToolbarView(store: store)
//    }
//    .task(id: canvasSize) {
//      print("This should only update once in a while, on actual canvas size changes, right?")
//      store.canvasSize = canvasSize
//    }
//  }
//}
//
//extension ZoomView {
//  
//  private func handleEventData(_ eventData: TouchEventData) {
//    /// Send data through to child view
//    didUpdateEventData(eventData)
//    
//    /// Send events to `GestureStateHandler`
//    store.gestureState.update(
//      event: eventData,
//      in: store.viewportSize.toCGRect
//    )
//  }
//}
//
//
//#if DEBUG
//@available(macOS 15, iOS 18, *)
//#Preview(traits: .size(.narrow)) {
//  ZoomView(canvasSize: CGSize.init(width: 400, height: 300), didUpdateEventData: { _ in }) {
//    Text(TestStrings.paragraphs[5])
//      .padding(40)
//      .background(.purple.quinary)
//      .frame(width: 400)
//
//  }
//  .frame(width: 600, height: 700)
//  .background(.black.opacity(0.6))
//}
//#endif
