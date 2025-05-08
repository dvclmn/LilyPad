//
//  DrawingView.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI

public struct DrawingView: View {
  //  @Environment(AppHandler.self) private var store
  @State private var store = DrawingHandler()

  public typealias ArtworkUpdate = (Artwork) async -> Void

  let eventData: TouchEventData
  let canvasSize: CGSize
  let config: StrokeConfiguration
  var onArtworkUpdate: ArtworkUpdate

  public init(
    eventData: TouchEventData,
    canvasSize: CGSize,
    config: StrokeConfiguration,
    onArtworkUpdate: @escaping ArtworkUpdate
  ) {
    self.eventData = eventData
    self.canvasSize = canvasSize
    self.config = config
    self.onArtworkUpdate = onArtworkUpdate
  }
  public var body: some View {

    Canvas {
      context,
      _ in

      for stroke in store.strokeHandler.allStrokes {

        store.strokeHandler.engine.drawStroke(
          stroke,
          config: config,
          in: context
        )

        /// Shows location of points and handles
        //          context.debugPath(path: basePath)

      }  // END stroke loop
    }
    .background(.gray.opacity(0.2))
    .clipShape(.rect(cornerRadius: 20))
    .frame(
      width: canvasSize.width,
      height: canvasSize.height
    )
    .allowsHitTesting(false)
    .task(id: config) {
      store.strokeHandler.config = config
    }
    
    .task(id: store.strokeHandler.artwork) {
      await onArtworkUpdate(store.strokeHandler.artwork)
    }


  }
}

extension DrawingView {


  //  func renderStrokes(
  //    points: [CGPoint],
  //    widths: inout [CGFloat],
  //    context: inout GraphicsContext
  //  ) {
  //    /// Handle empty widths case
  //    if widths.isEmpty {
  //      widths = Array(repeating: 5.0, count: points.count)
  //    }/// Handle case where widths.count < points.count
  //    else if widths.count < points.count {
  //
  //      /// Only interpolate if we have at least 2 widths to work with
  //      if widths.count >= 2 {
  //        let step = CGFloat(widths.count - 1) / CGFloat(points.count - 1)
  //        var interpolatedWidths: [CGFloat] = []
  //        for i in 0..<points.count {
  //          let pos = CGFloat(i) * step
  //          let lowerIndex = Int(pos)
  //          let upperIndex = min(lowerIndex + 1, widths.count - 1)
  //          let fraction = pos - CGFloat(lowerIndex)
  //
  //          let lowerWidth = widths[lowerIndex]
  //          let upperWidth = widths[upperIndex]
  //          let interpolated = lowerWidth + (upperWidth - lowerWidth) * fraction
  //          interpolatedWidths.append(interpolated)
  //        }
  //        widths = interpolatedWidths
  //      } else {
  //        /// Fall back to padding with last width
  //        let lastWidth = widths.last ?? 5.0
  //        widths += Array(repeating: lastWidth, count: points.count - widths.count)
  //      }
  //    }/// If widths.count > points.count, truncate (shouldn't happen, but just in case)
  //    else if widths.count > points.count {
  //      widths = Array(widths[0..<points.count])
  //    }
  //
  //    /// Now we can safely assume widths.count == points.count
  //    for i in 0..<points.count where i < points.count - 1 {
  //      let p1 = points[i]
  //      let p2 = points[i + 1]
  //      let width1 = widths[i]
  //      let width2 = widths[i + 1]
  //
  //      let dx = p2.x - p1.x
  //      let dy = p2.y - p1.y
  //      let angle = atan2(dy, dx)
  //      let perp = CGVector(dx: -sin(angle), dy: cos(angle))
  //
  //      let a = CGPoint(x: p1.x + perp.dx * width1 / 2, y: p1.y + perp.dy * width1 / 2)
  //      let b = CGPoint(x: p1.x - perp.dx * width1 / 2, y: p1.y - perp.dy * width1 / 2)
  //      let c = CGPoint(x: p2.x - perp.dx * width2 / 2, y: p2.y - perp.dy * width2 / 2)
  //      let d = CGPoint(x: p2.x + perp.dx * width2 / 2, y: p2.y + perp.dy * width2 / 2)
  //
  //      let path = Path { path in
  //        path.move(to: a)
  //        path.addLine(to: b)
  //        path.addLine(to: c)
  //        path.addLine(to: d)
  //        path.closeSubpath()
  //      }
  //
  //      context.fill(path, with: .color(.purple))
  //    }
  //  }

  //  func renderBasicStrokes(
  //    points: [CGPoint],
  //    widths: [CGFloat],
  //    context: inout GraphicsContext
  //  ) {
  //    /// THIS WORKS
  //    for point in points {
  //      let debugCircle = Path(ellipseIn: CGRect(origin: point, size: CGSize(width: 2, height: 2)))
  //      context.fill(debugCircle, with: .color(.purple))
  //    }
  //  }
}
//#if DEBUG
//@available(macOS 15, iOS 18, *)
//#Preview(traits: .size(.normal)) {
//
//  CanvasView()
//    .environment(AppHandler())
//}
//#endif
