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

      Canvas {
        context,
        _ in
        
        /// Draw all strokes
        for stroke in handler.strokeHandler.allStrokes {
          let path = StrokePath.smoothPath(for: stroke)
          
          
          /// Draw the stroke with variable width
          for i in 0..<stroke.points.count {
            if i < stroke.points.count - 1 {
              /// Create segment path between points
              var segmentPath = Path()
              segmentPath.move(to: stroke.points[i])
              segmentPath.addLine(to: stroke.points[i+1])
              
              /// Average width between adjacent points
              let width = (stroke.widths[i] + stroke.widths[min(i+1, stroke.widths.count-1)]) / 2.0
              
              /// Draw the segment with the calculated width
//              context.stroke(
//                segmentPath,
//                with: .color(stroke.color),
//                style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round)
//              )
              
              let p1 = stroke.points[i]
              let p2 = stroke.points[i+1]
              
              let width1 = stroke.widths[i]
              let width2 = stroke.widths[i+1]
              
              let dx = p2.x - p1.x
              let dy = p2.y - p1.y
              let angle = atan2(dy, dx)
              let perp = CGVector(dx: -sin(angle), dy: cos(angle))
              
              let a = CGPoint(x: p1.x + perp.dx * width1 / 2, y: p1.y + perp.dy * width1 / 2)
              let b = CGPoint(x: p1.x - perp.dx * width1 / 2, y: p1.y - perp.dy * width1 / 2)
              let c = CGPoint(x: p2.x - perp.dx * width2 / 2, y: p2.y - perp.dy * width2 / 2)
              let d = CGPoint(x: p2.x + perp.dx * width2 / 2, y: p2.y + perp.dy * width2 / 2)
              
              let path = Path { path in
                path.move(to: a)
                path.addLine(to: b)
                path.addLine(to: c)
                path.addLine(to: d)
                path.closeSubpath()
              }
              
              context.fill(path, with: .color(stroke.color))
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
