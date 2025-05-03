//
//  FingerPaint.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI

public struct FingerPaintCanvasView: View {
  @StateObject private var viewModel = FingerPaintViewModel()
  @State private var canvasSize: CGSize = .zero
  
  public init() {}
  
  public var body: some View {
    ZStack {
      // Canvas to draw strokes
      Canvas { context, size in
        // Store the canvas size
        if canvasSize != size {
          DispatchQueue.main.async {
            canvasSize = size
          }
        }
        
        // Draw all strokes
        for stroke in viewModel.strokeBuilder.allStrokes {
          let path = viewModel.strokeBuilder.smoothPath(for: stroke)
          
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
        }
      }
      .background(Color(white: 0.95))
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { _ in } // For debugging only, actual drawing uses TrackpadTouchesView
      )
      
      // Invisible TrackpadTouchesView to capture touches
      TrackpadTouchesView(onTouchesUpdate: { touches in
        viewModel.processTouches(touches)
      })
      .allowsHitTesting(true)
      
      // Clear button
      VStack {
        Spacer()
        HStack {
          Spacer()
          Button("Clear") {
            viewModel.clearStrokes()
          }
          .padding()
          .background(Color.white.opacity(0.8))
          .cornerRadius(8)
          .padding()
        }
      }
    }
  }
}

/// SwiftUI wrapper for TrackpadTouchesNSView
struct TrackpadTouchesView: NSViewRepresentable {
  var onTouchesUpdate: (Set<TrackpadTouch>) -> Void
  
  func makeNSView(context: Context) -> TrackpadTouchesNSView {
    let view = TrackpadTouchesNSView(frame: .zero)
    view.delegate = context.coordinator
    return view
  }
  
  func updateNSView(_ nsView: TrackpadTouchesNSView, context: Context) {
    // Update view if needed
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(onTouchesUpdate: onTouchesUpdate)
  }
  
  class Coordinator: NSObject, TrackpadTouchesDelegate {
    let onTouchesUpdate: (Set<TrackpadTouch>) -> Void
    
    init(onTouchesUpdate: @escaping (Set<TrackpadTouch>) -> Void) {
      self.onTouchesUpdate = onTouchesUpdate
    }
    
    func touchesView(_ view: TrackpadTouchesNSView, didUpdateTouches touches: Set<TrackpadTouch>) {
      onTouchesUpdate(touches)
    }
  }
}

/// View model for the finger paint canvas
class FingerPaintViewModel: ObservableObject {
  let strokeBuilder = StrokePathBuilder()
  
  /// Process touch updates
  func processTouches(_ touches: Set<TrackpadTouch>) {
    strokeBuilder.processTouches(touches)
    // Force UI update
    objectWillChange.send()
  }
  
  /// Clear all strokes
  func clearStrokes() {
    strokeBuilder.clearStrokes()
    objectWillChange.send()
  }
}
