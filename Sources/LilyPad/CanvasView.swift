//
//  CanvasView.swift
//  LilyPad
//
//  Created by Dave Coleman on 4/5/2025.
//

import BaseHelpers
import BaseComponents
import SwiftUI

public struct CanvasView: View {

  let handler: TouchHandler

  public var body: some View {


    Canvas { context, _ in

      /// Draw all strokes
      for stroke in handler.allStrokes {
        let path = handler.smoothPath(for: stroke)

        context.stroke(
          path,
          with: .color(stroke.color),
          style: StrokeStyle(
            lineWidth: 5,
            lineCap: .round,
            lineJoin: .round
          )
        )  // END context stroke

        context.debugPath(path: path)

      }
    }
    .background(.gray.opacity(0.2))

  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.normal)) {
  let handler = TouchHandler()
  CanvasView(handler: handler)
}
#endif
