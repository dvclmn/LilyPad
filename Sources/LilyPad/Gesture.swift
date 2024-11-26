//
//  Gesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//


import SwiftUI

// 3. Create the NSViewRepresentable
struct TrackpadGestureView: NSViewRepresentable {
  @Binding var gestureState: TrackpadGestureState
  var onGestureUpdate: ((TrackpadGestureState) -> Void)?
  
  class Coordinator: NSObject, TrackpadGestureDelegate {
    var parent: TrackpadGestureView
    
    init(parent: TrackpadGestureView) {
      self.parent = parent
    }
    
    func didUpdateGesture(_ state: TrackpadGestureState) {
      Task { @MainActor [state] in
        self.parent.gestureState = state
        self.parent.onGestureUpdate?(state)
      }
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  func makeNSView(context: Context) -> GestureDetectingView {
    let view = GestureDetectingView()
    view.delegate = context.coordinator
    return view
  }
  
  func updateNSView(_ nsView: GestureDetectingView, context: Context) {
    // Update view if needed
  }
}



// 1. First, let's create a struct to hold gesture state
struct TrackpadGestureState {
  var scrollDeltaX: CGFloat = 0
  var scrollDeltaY: CGFloat = 0
  var magnification: CGFloat = 1.0
  var rotation: CGFloat = 0
  var phase: NSEvent.Phase = []
}


// 2. Create a protocol for gesture callbacks
protocol TrackpadGestureDelegate: AnyObject {
  func didUpdateGesture(_ state: TrackpadGestureState)
}


// 4. Create a custom NSView to handle the gestures
class GestureDetectingView: NSView {
  weak var delegate: TrackpadGestureDelegate?
  private var gestureState = TrackpadGestureState()
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupGestureRecognizers()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupGestureRecognizers()
  }
  
  private func setupGestureRecognizers() {
    // Enable gesture recognition
    self.wantsRestingTouches = true
    
    // Add magnification gesture recognizer
    let magnificationGesture = NSMagnificationGestureRecognizer(target: self, action: #selector(handleMagnification(_:)))
    self.addGestureRecognizer(magnificationGesture)
    
    
    // Add rotation gesture recognizer
    let rotationGesture = NSRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
    self.addGestureRecognizer(rotationGesture)
  }
  
  override func scrollWheel(with event: NSEvent) {
    gestureState.scrollDeltaX += event.scrollingDeltaX
    gestureState.scrollDeltaY += event.scrollingDeltaY
    gestureState.phase = event.phase
    delegate?.didUpdateGesture(gestureState)
  }
  
  @objc private func handleMagnification(_ gesture: NSMagnificationGestureRecognizer) {
    gestureState.magnification = gesture.magnification + 1.0
    
    // Update phase based on gesture state
    switch gesture.state {
      case .began:
        gestureState.phase = .began
      case .changed:
        gestureState.phase = .changed
      case .ended:
        gestureState.phase = .ended
      case .cancelled:
        gestureState.phase = .cancelled
      default:
        gestureState.phase = []
    }
    
    delegate?.didUpdateGesture(gestureState)
  }
  
  @objc private func handleRotation(_ gesture: NSRotationGestureRecognizer) {
    gestureState.rotation = gesture.rotation
    delegate?.didUpdateGesture(gestureState)
  }
}

// 5. Create a SwiftUI view modifier
struct TrackpadGestureModifier: ViewModifier {
  @State private var gestureState = TrackpadGestureState()
  var onGestureUpdate: ((TrackpadGestureState) -> Void)?
  
  func body(content: Content) -> some View {
    ZStack {
      content
      TrackpadGestureView(gestureState: $gestureState, onGestureUpdate: onGestureUpdate)
    }
  }
}

// 6. Add convenience View extension
extension View {
  func trackpadGestures(onUpdate: @escaping (TrackpadGestureState) -> Void) -> some View {
    modifier(TrackpadGestureModifier(onGestureUpdate: onUpdate))
  }
}

