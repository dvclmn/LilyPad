//
//  TouchDebugView.swift
//  LilyPad
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI
import BaseComponents

public struct TouchDebugView: View {
  
  let handler: AppHandler
  
  public var body: some View {
    
    // Debug items
    Grid {
      ForEach(TouchDebugItem.allCases) { item in
        GridRow {
          Text(item.name)
            .gridCellAnchor(.leading)
          Text(valueString(item))
            .gridCellAnchor(.trailing)
            .fontWeight(.medium)
            .monospaced()
            .foregroundStyle(booleanColour(valueString(item)))
        }
        Divider()
          .gridCellUnsizedAxes(.horizontal)
      }
    }
    .padding()
    .background(.black.opacity(0.7))
    .clipShape(.rect(cornerRadius: 6))
    

  }
}

extension TouchDebugView {
  func booleanColour(_ value: String) -> Color {
    switch value {
      case "true": Color.orange
      case "false": Color.red
      default: Color.gray
    }
  }
  
  func valueString(_ item: TouchDebugItem) -> String {
    switch item {
      case .pointerLocked: handler.isPointerLocked.description
      case .touchModeActive: handler.isInTouchMode.description
      case .clickedDown: handler.isClicked.description
      case .touchCount: handler.touches.count.string
    }
  }

}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.normal)) {
  TouchDebugView(handler: AppHandler())
}
#endif

