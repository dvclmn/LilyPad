//
//  ZoomToolbarView.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI

public struct ZoomToolbarView: ToolbarContent {
  
  @Bindable var store: ZoomHandler
  
  public var body: some ToolbarContent {
    
    ToolbarItemGroup {
      HStack {
        LabeledContent("Viewport", value: store.viewportSize.displayString(decimalPlaces: 0))
        Divider()
        LabeledContent("Pan", value: store.gestureState.pan.offset.displayString(style: .full))
        Divider()
        LabeledContent("Zoom", value: store.gestureState.zoom.scale.displayString)
      }
      .foregroundStyle(.tertiary)
      .font(.callout)
      .monospacedDigit()
      Button {
        store.gestureState.pan.offset = .zero
//        store.offset = .zero
      } label: {
        Label("Reset pan", systemImage: "hand.draw")
      }
    }
    
  }
}

