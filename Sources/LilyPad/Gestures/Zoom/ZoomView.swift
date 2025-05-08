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

  public typealias Output = (TouchEventData) -> Content
  
  @State private var store = ZoomHandler()
  let zoomThreshold: CGFloat = 40
  let scaleThresholdDistance: CGFloat = 10

  let canvasSize: CGSize
  let content: Output

  public init(
    canvasSize: CGSize,
    @ViewBuilder content: @escaping Output
  ) {
    self.canvasSize = canvasSize
    self.content = content
  }

  public var body: some View {
    
    @Bindable var store = store

    /// Using `GeometryReader` to kind 'reset' everything to be full width,
    /// full height, and top leading.
    GeometryReader { proxy in
#warning("`.mouseLock(store.eventData.touches.count == 2)` will need to be based on better metrics than this")

      content(store.eventData)
        //      Rectangle()
        //        .fill(.white.opacity(0.1))
        .midpointIndicator()
        .frame(width: store.canvasSize.width, height: store.canvasSize.height)
        .scaleEffect(store.scale)
        .position(store.canvasPosition)
        .drawingGroup()
        .task(id: proxy.size) {
          store.viewportSize = proxy.size
        }
    }
    .midpointIndicator()
    
    .mouseLock(store.eventData.touches.count == 2)
    .touches { event in
      store.eventData = event
      store.gestureState.update(
        event: event,
        in: store.viewportSize.toCGRect
      )
    }
    .toolbar {
ZoomToolbarView(store: store)
    }
    .task(id: canvasSize) {
      store.canvasSize = canvasSize
    }
  }
}


#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.narrow)) {
  ZoomView(canvasSize: CGSize.init(width: 400, height: 300)) { event in
    Text(TestStrings.paragraphs[5])
      .padding(40)
      .background(.purple.quinary)
      .frame(width: 400)

  }
  .frame(width: 600, height: 700)
  .background(.black.opacity(0.6))
}
#endif
