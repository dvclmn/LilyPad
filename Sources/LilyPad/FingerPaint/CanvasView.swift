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
          let basePath = StrokePath.smoothPath(for: stroke)
          let widths = stroke.widths

          /// THIS WORKS
          //                    for point in basePoints {
          //          for point in stroke.points {
          //            let debugCircle = Path(ellipseIn: CGRect(origin: point, size: CGSize(width: 2, height: 2)))
          //            context.fill(debugCircle, with: .color(.purple))
          //          }


          // Ensure points and widths arrays have the same count
          guard stroke.points.count == stroke.widths.count else {
            print("Mismatch in number of points `\(stroke.points.count)` and widths `\(stroke.widths.count)")
            continue
          }
          
          for i in 0..<stroke.points.count {
            if i < stroke.points.count - 1 {
              /// Create segment path between points
              var segmentPath = Path()
              segmentPath.move(to: stroke.points[i])
              segmentPath.addLine(to: stroke.points[i + 1])
              
              /// Average width between adjacent points
              let width = (stroke.widths[i] + stroke.widths[min(i + 1, stroke.widths.count - 1)]) / 2.0
              
              let p1 = stroke.points[i]
              let p2 = stroke.points[i + 1]
              
              // Safe access to widths
              let width1 = stroke.widths[i]
              let width2 = stroke.widths[i + 1] // This is now safe because of the guard and the i < count-1 check
              
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
              
              context.fill(path, with: .color(.purple))
            }
          }


          var leftEdge: [CGPoint] = []
          var rightEdge: [CGPoint] = []

          for i in 0..<basePoints.count {
            guard i < widths.count else { continue }
            
            let p = basePoints[i]

            let width = widths[i]

            // Compute direction (tangent)
            //            let prev = basePoints[max(i - 1, 0)]
            //            let next = basePoints[min(i + 1, basePoints.count - 1)]

            guard basePoints.count >= 2 else { continue }

            let prev = i > 0 ? basePoints[i - 1] : basePoints[i]
            let next = i < basePoints.count - 1 ? basePoints[i + 1] : basePoints[i]

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
            guard !leftEdge.isEmpty, !rightEdge.isEmpty else { return }
            path.move(to: leftEdge[0])

            for point in leftEdge.dropFirst() { path.addLine(to: point) }
            for point in rightEdge { path.addLine(to: point) }
            path.closeSubpath()
          }

          context.fill(fullPath, with: .color(.orange))


          /// Shows location of points and handles
          //          context.debugPath(path: fullPath)
        }  // END stroke loop
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
