//
//  CanvasDebugView.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import BaseHelpers
import SwiftUI

public struct CanvasDebugView: View {

  @Bindable var store: CanvasGestureHandler
  public var body: some View {

    Form {

      Section("Zoom") {
        Text(
          """
          Level: \(store.zoom.toPercentString(within: store.zoomRange.toCGFloatRange))
          Range: \(store.zoomRange.toCGFloatRange)
          """
        )
      }

      Section("Pan") {
        Text(
          """
          Offset: \(store.pan.displayString)
          Phase: \(store.pan.displayString)
          Total Distance: \(store.totalPanDistance.displayString)
          """
        )
      }
    }
    .formStyle(.grouped)
    .monospacedDigit()
    .frame(width: 260, height: 300)
    .scrollContentBackground(.hidden)
    .background {
      RoundedRectangle(cornerRadius: 8)
        .fill(.regularMaterial)
    }
    .padding()

  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.normal)) {
  @Previewable @State var store = CanvasGestureHandler()
  CanvasDebugView(store: store)
}
#endif
