//
//  ZoomToolbarView.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI

public struct ZoomToolbarView: ToolbarContent {
  
  public var body: some ToolbarContent {
    
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
}

