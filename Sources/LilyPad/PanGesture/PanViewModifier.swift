//
//  TestPanGestureModifier.swift
//  Paperbark
//
//  Created by Dave Coleman on 24/6/2025.
//

//import AppKit
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


public struct DrawingCanvasView: View {
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

        // Could add momentum/deceleration here
        print("Pan gesture ended. Total distance: \(totalDistance)")

      case .cancelled:
        currentPhase = "Cancelled"
        // Could revert to previous state or handle cancellation
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

// MARK: - Demo App
//struct ContentView: View {
//  var body: some View {
//    TabView {
//      DrawingCanvasView()
//        .tabItem {
//          Label("Advanced", systemImage: "paintbrush")
//        }
//
//      SimpleUsageExample()
//        .tabItem {
//          Label("Simple", systemImage: "hand.tap")
//        }
//    }
//  }
//}


//
//// MARK: - SwiftUI Representable
//struct PanGestureView: NSViewRepresentable {
//  let onPanGesture: (CGPoint, NSEvent.Phase) -> Void
//
//  func makeNSView(context: Context) -> PanTrackingView {
//    let view = PanTrackingView()
//    view.onPanGesture = onPanGesture
//    return view
//  }
//
//  func updateNSView(_ nsView: PanTrackingView, context: Context) {
//    nsView.onPanGesture = onPanGesture
//  }
//}
//
//// MARK: - Custom NSView for Pan Tracking
//class PanTrackingView: NSView {
//  var onPanGesture: ((CGPoint, NSEvent.Phase) -> Void)?
//
//  override init(frame frameRect: NSRect) {
//    super.init(frame: frameRect)
//    setupView()
//  }
//
//  required init?(coder: NSCoder) {
//    super.init(coder: coder)
//    setupView()
//  }
//
//  private func setupView() {
//    // Accept first responder to receive scroll events
////    wantsLayer = true
////    layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
//  }
//
//  override var acceptsFirstResponder: Bool {
//    return true
//  }
//
//  override func viewDidMoveToWindow() {
//    super.viewDidMoveToWindow()
//    // Ensure we can become first responder
//    window?.makeFirstResponder(self)
//  }
//
//  // MARK: - Two-Finger Pan via ScrollWheel
//  override func scrollWheel(with event: NSEvent) {
//    // Filter for trackpad events (two-finger gestures)
//    guard event.subtype == .touch else {
//      super.scrollWheel(with: event)
//      return
//    }
//
//    // Get the scroll delta
//    let deltaX = event.scrollingDeltaX
//    let deltaY = event.scrollingDeltaY
//    let delta = CGPoint(x: deltaX, y: deltaY)
//
//    // Get the gesture phase
//    let phase = event.phase
//
//    // Call the callback with delta and phase
//    onPanGesture?(delta, phase)
//
//    // Uncomment to prevent the event from propagating further
//    // Don't call super.scrollWheel(with: event)
//  }
//
//  // MARK: - Alternative: Using NSPanGestureRecognizer
////  private func setupPanGestureRecognizer() {
////    let panGesture = NSPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
////    panGesture.buttonMask = 0x1 // Primary button
////    addGestureRecognizer(panGesture)
////  }
////
////  @objc private func handlePanGesture(_ gesture: NSPanGestureRecognizer) {
////    let translation = gesture.translation(in: self)
////
////    // Convert NSGestureRecognizer.State to NSEvent.Phase for consistency
////    let phase: NSEvent.Phase
////    switch gesture.state {
////      case .began:
////        phase = .began
////      case .changed:
////        phase = .changed
////      case .ended:
////        phase = .ended
////      case .cancelled:
////        phase = .cancelled
////      default:
////        return
////    }
////
////    onPanGesture?(translation, phase)
////
////    // Reset translation to get delta for next event
////    gesture.setTranslation(.zero, in: self)
////  }
//}
//
//import SwiftUI
//
//public struct ExampleModifier: ViewModifier {
//
//  @State private var panOffset: CGPoint = .zero
//  @State private var currentPhase: NSEvent.Phase = .stationary
//
//  public func body(content: Content) -> some View {
//    PanGestureView { delta, phase in
//      handlePanGesture(delta: delta, phase: phase)
//    }
////    VStack {
////      Text("Two-Finger Pan Gesture")
////        .font(.title)
////
////      .frame(width: 400, height: 300)
////      .border(Color.gray)
////
////      VStack(alignment: .leading) {
////        Text("Pan Offset: \(panOffset.x, specifier: "%.1f"), \(panOffset.y, specifier: "%.1f")")
////        Text("Phase: \(phaseDescription(currentPhase))")
////      }
////      .padding()
////    }
////    .padding()
////    content
//  }
//}
//extension ExampleModifier {
//  private func handlePanGesture(delta: CGPoint, phase: NSEvent.Phase) {
//    currentPhase = phase
//
//    switch phase {
//      case .began:
//        // Reset or initialize pan state
//        break
//      case .changed:
//        // Accumulate the pan offset for drawing
//        panOffset.x += delta.x
//        panOffset.y += delta.y
//      case .ended, .cancelled:
//        // Finalize or reset pan state
//        break
//      default:
//        break
//    }
//  }
//
//  private func phaseDescription(_ phase: NSEvent.Phase) -> String {
//    switch phase {
//      case .began: return "Began"
//      case .changed: return "Changed"
//      case .ended: return "Ended"
//      case .cancelled: return "Cancelled"
//      case .stationary: return "Stationary"
//      default: return "Unknown"
//    }
//  }
//}
////extension View {
////  public func example() -> some View {
////    self.modifier(ExampleModifier())
////  }
////}
