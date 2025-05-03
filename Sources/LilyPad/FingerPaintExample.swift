//
//  FingerPaintExample.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI

//public struct FingerPaintExampleView: View {
//  
//  @State private var selectedColor: Color = .blue
//  @State private var strokeWidth: CGFloat = 10.0
//  @State private var showDebugInfo: Bool = false
////  @StateObject private var viewModel = FingerPaintCanvasViewModel()
//  
//  @Binding var handler: TouchHandler
//  
//  // Available colors for painting
//  let availableColors: [Color] = [
//    .black, .blue, .red, .green, .orange, .purple, .pink
//  ]
//  
//  public init(
//    _ handler: Binding<TouchHandler>
//  ) {
//    self._handler = handler
//  }
//  
//  public var body: some View {
//    VStack(spacing: 0) {
//      // Toolbar
//      HStack {
//        Text("Trackpad Finger Paint")
//          .font(.headline)
//        
//        Spacer()
//        
//        // Color picker
//        HStack {
//          Text("Color:")
//          ForEach(availableColors, id: \.self) { color in
//            Circle()
//              .fill(color)
//              .frame(width: 24, height: 24)
//              .overlay(
//                Circle()
//                  .stroke(selectedColor == color ? Color.white : Color.clear, lineWidth: 2)
//              )
//              .background(
//                Circle()
//                  .stroke(Color.black.opacity(0.3), lineWidth: 1)
//              )
//              .onTapGesture {
//                selectedColor = color
//                viewModel.currentColor = color
//              }
//          }
//        }
//        
//        Divider()
//          .frame(height: 20)
//          .padding(.horizontal)
//        
//        // Base width slider
//        VStack(alignment: .leading) {
//          Text("Base Width: \(Int(strokeWidth))")
//            .font(.caption)
//          
//          Slider(value: $strokeWidth, in: 2...30) { changed in
//            if changed {
//              handler.baseStrokeWidth = strokeWidth
//            }
//          }
//          .frame(width: 150)
//        }
//        
//        Divider()
//          .frame(height: 20)
//          .padding(.horizontal)
//        
//        // Debug toggle
//        Toggle("Debug Info", isOn: $showDebugInfo)
//        
//        Button("Clear") {
//          handler.clearStrokes()
//        }
//        .padding(.horizontal)
//      }
//      .padding()
//      .background(Color(NSColor.windowBackgroundColor))
//      
//      // Main canvas area
//      ZStack {
//        // Enhanced canvas view
//        EnhancedFingerPaintCanvasView(handler: handler)
//          .background(Color(white: 0.95))
//        
//        // Debug overlay
//        if showDebugInfo {
//          VStack {
//            Spacer()
//            HStack {
//              VStack(alignment: .leading) {
//                Text("Active touches: \(viewModel.activeTouches.count)")
//                ForEach(Array(viewModel.activeTouches), id: \.id) { touch in
//                  Text("Touch \(touch.id): pos=(\(String(format: "%.2f", touch.position.x)), \(String(format: "%.2f", touch.position.y))), speed=\(String(format: "%.2f", touch.speed))")
//                    .font(.system(.caption, design: .monospaced))
//                }
//              }
//              .padding()
//              .background(Color.black.opacity(0.7))
//              .foregroundColor(.white)
//              .cornerRadius(8)
//              
//              Spacer()
//            }
//            .padding()
//          }
//        }
//      }
//    }
//  }
//}
//#if DEBUG
//#Preview {
//  FingerPaintExampleView()
//}
//#endif
//

///// Enhanced canvas view that shows touches and strokes
//struct EnhancedFingerPaintCanvasView: View {
////  @ObservedObject var viewModel: FingerPaintCanvasViewModel
//  @Binding var handler: TouchHandler
//  
//  var body: some View {
//    ZStack {
//      // Canvas to draw strokes with variable width
//      Canvas { context, size in
//        // Draw all strokes
//        for stroke in handler.allStrokes {
//          // Draw the stroke with variable width segments
//          for i in 0..<stroke.points.count - 1 {
//            var segmentPath = Path()
//            segmentPath.move(to: stroke.points[i])
//            
//            if stroke.points.count >= 3 && i < stroke.points.count - 2 {
//              // Use quadratic curve for smoother lines
//              let midPoint = CGPoint(
//                x: (stroke.points[i+1].x + stroke.points[i+2].x) / 2,
//                y: (stroke.points[i+1].y + stroke.points[i+2].y) / 2
//              )
//              segmentPath.addQuadCurve(to: midPoint, control: stroke.points[i+1])
//            } else {
//              // Default to line for last segment
//              segmentPath.addLine(to: stroke.points[i+1])
//            }
//            
//            // Get width for this segment
//            let width = stroke.widths[i]
//            
//            // Draw the segment with the calculated width
//            context.stroke(segmentPath, with: .color(stroke.color), style: StrokeStyle(
//              lineWidth: width,
//              lineCap: .round,
//              lineJoin: .round
//            ))
//          }
//        }
//      }
//      
//      // Invisible TrackpadTouchesView to capture touches
//      TrackpadTouchesView(onTouchesUpdate: { touches in
//        viewModel.processTouches(touches)
//      })
//    }
//  }
//}
//
///// View model for the enhanced finger paint canvas
//class FingerPaintCanvasViewModel: ObservableObject {
//  // The stroke builder and data structures
//  private var strokeBuilder = StrokePathBuilder()
//  private var touchManager = TrackpadTouchManager()
//  
//  // Settings
//  var baseStrokeWidth: CGFloat = 10.0 {
//    didSet {
//      strokeBuilder.setBaseStrokeWidth(baseStrokeWidth)
//    }
//  }
//  
//  var currentColor: Color = .blue {
//    didSet {
//      strokeBuilder.setCurrentColor(currentColor)
//    }
//  }
//  
//  // For debug purposes
//  @Published var activeTouches: Set<TrackpadTouch> = []
//  
//  init() {
//    strokeBuilder.setBaseStrokeWidth(baseStrokeWidth)
//    strokeBuilder.setCurrentColor(currentColor)
//  }
//  
//  /// Process touch updates
//  func processTouches(_ touches: Set<TrackpadTouch>) {
//    strokeBuilder.processTouches(touches)
//    self.activeTouches = touches
//    // Force UI update
//    objectWillChange.send()
//  }
//  
//  /// Get all current strokes
//  var allStrokes: [TouchStroke] {
//    return strokeBuilder.allStrokes
//  }
//  
//  /// Clear all strokes
//  func clearStrokes() {
//    strokeBuilder.clearStrokes()
//    objectWillChange.send()
//  }
//}
