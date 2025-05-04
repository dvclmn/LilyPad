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
          var widths = stroke.widths

//          renderBasicStrokes(points: stroke.points, widths: widths, context: &context)
          
//          renderStrokes(
//            points: stroke.points,
//            widths: &widths,
//            context: &context
//          )
          renderStrokesAlt(
            points: stroke.points,
            widths: widths,
            context: &context
          )

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

extension CanvasView {

  func renderStrokesAlt(
    points: [CGPoint],
    widths: [CGFloat],
    context: inout GraphicsContext
  ) {

    var leftEdge: [CGPoint] = []
    var rightEdge: [CGPoint] = []

    for i in 0..<points.count where i < widths.count {

      let p = points[i]

      let width = widths[i]

      // Compute direction (tangent)
      //            let prev = points[max(i - 1, 0)]
      //            let next = points[min(i + 1, points.count - 1)]

      guard points.count >= 2 else { continue }

      let prev = i > 0 ? points[i - 1] : points[i]
      let next = i < points.count - 1 ? points[i + 1] : points[i]

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

  }

  func renderStrokes(
    points: [CGPoint],
    widths: inout [CGFloat],
    context: inout GraphicsContext
  ) {
    // Handle empty widths case
    if widths.isEmpty {
      widths = Array(repeating: 5.0, count: points.count)
    }
    // Handle case where widths.count < points.count
    else if widths.count < points.count {
      // Only interpolate if we have at least 2 widths to work with
      if widths.count >= 2 {
        let step = CGFloat(widths.count - 1) / CGFloat(points.count - 1)
        var interpolatedWidths: [CGFloat] = []
        for i in 0..<points.count {
          let pos = CGFloat(i) * step
          let lowerIndex = Int(pos)
          let upperIndex = min(lowerIndex + 1, widths.count - 1)
          let fraction = pos - CGFloat(lowerIndex)

          let lowerWidth = widths[lowerIndex]
          let upperWidth = widths[upperIndex]
          let interpolated = lowerWidth + (upperWidth - lowerWidth) * fraction
          interpolatedWidths.append(interpolated)
        }
        widths = interpolatedWidths
      } else {
        // Fall back to padding with last width
        let lastWidth = widths.last ?? 5.0
        widths += Array(repeating: lastWidth, count: points.count - widths.count)
      }
    }
    // If widths.count > points.count, truncate (shouldn't happen, but just in case)
    else if widths.count > points.count {
      widths = Array(widths[0..<points.count])
    }

    // Now we can safely assume widths.count == points.count

    for i in 0..<points.count where i < points.count - 1 {
      let p1 = points[i]
      let p2 = points[i + 1]
      let width1 = widths[i]
      let width2 = widths[i + 1]

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

  func renderBasicStrokes(
    points: [CGPoint],
    widths: [CGFloat],
    context: inout GraphicsContext
  ) {
    /// THIS WORKS
    for point in points {
      let debugCircle = Path(ellipseIn: CGRect(origin: point, size: CGSize(width: 2, height: 2)))
      context.fill(debugCircle, with: .color(.purple))
    }
  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.normal)) {
  let handler = AppHandler()
  CanvasView(handler: handler)
}
#endif
