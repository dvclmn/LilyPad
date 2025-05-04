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
          
          let basePoints = StrokePath.smoothPoints(for: stroke)
          let widths = stroke.widths

          var leftEdge: [CGPoint] = []
          var rightEdge: [CGPoint] = []
          
          for i in 0..<basePoints.count {
            let p = basePoints[i]
            let width = widths[i]
            
            // Compute direction (tangent)
            let prev = basePoints[max(i - 1, 0)]
            let next = basePoints[min(i + 1, basePoints.count - 1)]
            let dx = next.x - prev.x
            let dy = next.y - prev.y
            let angle = atan2(dy, dx)
            
            let perp = CGVector(dx: -sin(angle), dy: cos(angle))
            let offset = width / 2
            
            let left = CGPoint(x: p.x + perp.dx * offset, y: p.y + perp.dy * offset)
            let right = CGPoint(x: p.x - perp.dx * offset, y: p.y - perp.dy * offset)
            
            leftEdge.append(left)
            rightEdge.append(right)
          }
          
          // Reverse right edge for proper winding
          rightEdge.reverse()
          
          // Combine and draw
          let fullPath = Path { path in
            path.move(to: leftEdge[0])
            for point in leftEdge.dropFirst() { path.addLine(to: point) }
            for point in rightEdge { path.addLine(to: point) }
            path.closeSubpath()
          }
          
          context.fill(fullPath, with: .color(stroke.color))
          
          /// Shows location of points and handles
          context.debugPath(path: fullPath)
        } // END stroke loop
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
