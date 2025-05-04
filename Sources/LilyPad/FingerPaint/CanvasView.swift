//
//  CanvasView.swift
//  LilyPad
//
//  Created by Dave Coleman on 4/5/2025.
//

import BaseComponents
import BaseHelpers
import SwiftUI

public struct CanvasView: View {

  let handler: AppHandler

  public var body: some View {

    ZStack {

      TouchIndicatorsView(handler: handler)

      Canvas { context, _ in

        /// Draw all strokes
        for stroke in handler.strokeHandler.allStrokes {
          let path = StrokePath.smoothPath(for: stroke)

          // Ensure we have at least 2 points and matching widths
          guard stroke.points.count >= 2,
                  stroke.widths.count >= 2,
                stroke.points.count == stroke.widths.count else {
            continue  // Skip this stroke if conditions aren't met
          }
          
          context.stroke(
            path,
            with: .color(stroke.color),
            style: StrokeStyle(
              lineWidth: 5,
              lineCap: .round,
              lineJoin: .round
            )
          )  // END context stroke

          /// Shows location of points and handles
          context.debugPath(path: path)
        }
      }
      .background(.gray.opacity(0.2))

      .clipShape(.rect(cornerRadius: 20))
    }
    .frame(
      width: handler.trackPadSize.width,
      height: handler.trackPadSize.height
    )
    .allowsHitTesting(false)


  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.normal)) {
  let handler = AppHandler()
  CanvasView(handler: handler)
}
#endif
