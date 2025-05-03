//
//  FingerPaintExample.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI

public struct FingerPaintExampleView: View {
  
  @State private var selectedColor: Color = .blue
  @State private var strokeWidth: CGFloat = 10.0
  @State private var showDebugInfo: Bool = false
  @StateObject private var viewModel = FingerPaintCanvasViewModel()
  
  // Available colors for painting
  let availableColors: [Color] = [
    .black, .blue, .red, .green, .orange, .purple, .pink
  ]
  
  var body: some View {
    VStack(spacing: 0) {
      // Toolbar
      HStack {
        Text("Trackpad Finger Paint")
          .font(.headline)
        
        Spacer()
        
        // Color picker
        HStack {
          Text("Color:")
          ForEach(availableColors, id: \.self) { color in
            Circle()
              .fill(color)
              .frame(width: 24, height: 24)
              .overlay(
                Circle()
                  .stroke(selectedColor == color ? Color.white : Color.clear, lineWidth: 2)
              )
              .background(
                Circle()
                  .stroke(Color.black.opacity(0.3), lineWidth: 1)
              )
              .onTapGesture {
                selectedColor = color
                viewModel.currentColor = color
              }
          }
        }
        
        Divider()
          .frame(height: 20)
          .padding(.horizontal)
        
        // Base width slider
        VStack(alignment: .leading) {
          Text("Base Width: \(Int(strokeWidth))")
            .font(.caption)
          
          Slider(value: $strokeWidth, in: 2...30) { changed in
            if changed {
              viewModel.baseStrokeWidth = strokeWidth
            }
          }
          .frame(width: 150)
        }
        
        Divider()
          .frame(height: 20)
          .padding(.horizontal)
        
        // Debug toggle
        Toggle("Debug Info", isOn: $showDebugInfo)
        
        Button("Clear") {
          viewModel.clearStrokes()
        }
        .padding(.horizontal)
      }
      .padding()
      .background(Color(NSColor.windowBackgroundColor))
      
      // Main canvas area
      ZStack {
        // Enhanced canvas view
        EnhancedFingerPaintCanvasView(viewModel: viewModel)
          .background(Color(white: 0.95))
        
        // Debug overlay
        if showDebugInfo {
          VStack {
            Spacer()
            HStack {
              VStack(alignment: .leading) {
                Text("Active touches: \(viewModel.activeTouches.count)")
                ForEach(Array(viewModel.activeTouches), id: \.id) { touch in
                  Text("Touch \(touch.id): pos=(\(String(format: "%.2f", touch.position.x)), \(String(format: "%.2f", touch.position.y))), speed=\(String(format: "%.2f", touch.speed))")
                    .font(.system(.caption, design: .monospaced))
                }
              }
              .padding()
              .background(Color.black.opacity(0.7))
              .foregroundColor(.white)
              .cornerRadius(8)
              
              Spacer()
            }
            .padding()
          }
        }
      }
    }
  }
}
#if DEBUG
#Preview {
  FingerPaintExampleView()
}
#endif

