//
//  TestPanGestureModifier.swift
//  Paperbark
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI
import BaseHelpers

public struct PanGestureModifier: ViewModifier {
  let action: (PanPhase) -> Void

  public func body(content: Content) -> some View {
    GeometryReader { _ in
      content
      PanGestureView { phase in
        print("Received phase from `PanGestureView`: \(phase)")
        action(phase)
      }
    }
  }
}
extension View {
  public func onPanGesture(_ action: @escaping (PanPhase) -> Void) -> some View {
    modifier(PanGestureModifier(action: action))
  }
}


public struct CanvasExampleView: View {
  @State private var canvasOffset: CGPoint = .zero
  @State private var currentPhase: String = "Inactive"
  @State private var totalDistance: CGFloat = 0

  public init() {
//    self.canvasOffset = canvasOffset
//    self.currentPhase = currentPhase
//    self.totalDistance = totalDistance
  }
  public var body: some View {
    VStack {
      Text("SwiftUI-Style Pan Gesture API")
        .font(.title)

      // Main canvas area
      Rectangle()
        .fill(Color.blue.opacity(0.1))
//        .frame(width: 400, height: 300)
        .border(Color.gray)
        .overlay(
          Circle()
            .fill(Color.red)
            .frame(width: 20, height: 20)
            .offset(canvasOffset.toCGSize)
            .animation(.easeOut(duration: 0.1), value: canvasOffset)
            .allowsHitTesting(false)
        )
        .onPanGesture { phase in
          handlePanPhase(phase)
        }

      // Status display
      VStack(alignment: .leading, spacing: 8) {
        Text("Canvas Offset: (\(canvasOffset.x, specifier: "%.1f"), \(canvasOffset.y, specifier: "%.1f"))")
        Text("Current Phase: \(currentPhase)")
        Text("Total Distance: \(totalDistance, specifier: "%.1f")")
      }
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(8)
    }
    .padding()
  }

  private func handlePanPhase(_ phase: PanPhase) {
    switch phase {
      case .inactive:
        currentPhase = "Inactive"

      case .active(let delta):
        currentPhase = "Active"
        /// Apply delta to canvas offset for real-time panning
        canvasOffset.x += delta.x
        canvasOffset.y += delta.y

        /// Track total distance for analytics/gesture recognition
        let distance = sqrt(delta.x * delta.x + delta.y * delta.y)
        totalDistance += distance

      case .ended(let finalDelta):
        currentPhase = "Ended"
        /// Apply final delta
        canvasOffset.x += finalDelta.x
        canvasOffset.y += finalDelta.y

        /// Could add momentum/deceleration here
        print("Pan gesture ended. Total distance: \(totalDistance)")

      case .cancelled:
        currentPhase = "Cancelled"
        /// Could revert to previous state or handle cancellation
        print("Pan gesture cancelled")
    }
  }
}

// MARK: - Simple Usage Example
public struct SimpleUsageExample: View {
  @State private var panInfo = "No pan gesture"

  public init() {}
  public var body: some View {
    Rectangle()
      .fill(Color.green.opacity(0.3))
      .frame(width: 200, height: 150)
      .onPanGesture { phase in
        switch phase {
          case .inactive:
            panInfo = "Inactive"
          case .active(let delta):
            panInfo = "Panning: Δ(\(delta.x.displayString), \(delta.y.displayString))"
          case .ended(let finalDelta):
            panInfo = "Ended with final Δ(\(finalDelta.x.displayString), \(finalDelta.y.displayString))"
          case .cancelled:
            panInfo = "Cancelled"
        }
      }
      .overlay(
        Text(panInfo)
          .foregroundColor(.primary)
      )
  }
}
