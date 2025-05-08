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

  public typealias EventOutput = (TouchEventData) -> Void
//  public typealias Output = (TouchEventData) -> Content

  @State private var store = ZoomHandler()
  let zoomThreshold: CGFloat = 40
  let scaleThresholdDistance: CGFloat = 10

  let canvasSize: CGSize
  let didUpdateEventData: EventOutput?
  let content: Content

  public init(
    canvasSize: CGSize,
    didUpdateEventData: EventOutput? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.canvasSize = canvasSize
    self.didUpdateEventData = didUpdateEventData
    self.content = content()

    print("`ZoomView<Content: View>` created at \(Date.now.format(.timeDetailed))")

  }

  public var body: some View {

    @Bindable var store = store

    /// Using `GeometryReader` to kind 'reset' everything to be full width,
    /// full height, and top leading.
    GeometryReader { proxy in
      #warning("`.mouseLock(store.eventData.touches.count == 2)` will need to be based on better metrics than this")

      content
        //      Rectangle()
        //        .fill(.white.opacity(0.1))
        .midpointIndicator()
        .frame(width: store.canvasSize.width, height: store.canvasSize.height)
        .scaleEffect(store.zoom.scale)
        .position(store.canvasPosition)
        .drawingGroup()
        .task(id: proxy.size) {
          store.viewportSize = proxy.size
        }
    }
    .midpointIndicator()

    .mouseLock(store.eventData.touches.count == 2)
    
    .touches(viewSize: store.viewportSize) { eventData in
      
      if eventData.touches.count == 1, let didUpdateEventData {
        print("Event Data (for Drawing purposes) received from `TrackpadTouchesModifier`: \(eventData)")
        didUpdateEventData(eventData)
      } else {
        print("Event Data (for Gesture purposes) received from `TrackpadTouchesModifier`: \(eventData)")
        store.eventData = eventData
        store.updateGesture(
          event: eventData,
          in: store.viewportSize.toCGRect
        )
      }
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
  ZoomView(canvasSize: CGSize.init(width: 400, height: 300)) {
    Text(TestStrings.paragraphs[5])
      .padding(40)
      .background(.purple.quinary)
      .frame(width: 400)

  }
  .frame(width: 600, height: 700)
  .background(.black.opacity(0.6))
}
#endif
