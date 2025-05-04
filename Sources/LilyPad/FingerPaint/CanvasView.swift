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

          // Draw the stroke with variable width
          for i in 0..<stroke.points.count {
            if i < stroke.points.count - 1 {
              // Create segment path between points
              var segmentPath = Path()
              segmentPath.move(to: stroke.points[i])
              segmentPath.addLine(to: stroke.points[i+1])
              
              // Average width between adjacent points
              let width = (stroke.widths[i] + stroke.widths[min(i+1, stroke.widths.count-1)]) / 2.0
              
              // Draw the segment with the calculated width
              context.stroke(segmentPath, with: .color(stroke.color), style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
            }
          }
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
