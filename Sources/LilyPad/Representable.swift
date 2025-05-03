//
//  Representable.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

#if canImport(AppKit)
import SwiftUI
import AppKit

// MARK: - Data Models

/// Represents a normalized touch on the trackpad
public struct TrackpadTouch: Identifiable, Hashable {
  public let id: Int
  public let position: CGPoint
  public let timestamp: TimeInterval
  
  public init(_ nsTouch: NSTouch) {
    self.id = nsTouch.identity.hash
//    return TrackpadTouch(id: ObjectIdentifier(touch.identity as AnyObject).hashValue,
//                         location: location)
    self.position = CGPoint(
      x: nsTouch.normalizedPosition.x,
      y: 1.0 - nsTouch.normalizedPosition.y  // Flip Y to match SwiftUI coordinate system
    )
    self.timestamp = ProcessInfo.processInfo.systemUptime
  }
}

// MARK: - AppKit View

/// The underlying AppKit NSView that captures raw trackpad touches
public class TrackpadTouchesNSView: NSView {
  /// Delegate to forward touch events to
  weak var delegate: TrackpadTouchesDelegate?
  
  public override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    // Only interested in trackpad touches, not direct touches
    allowedTouchTypes = [.indirect]
    // Include stationary touches in the updates
    wantsRestingTouches = true
  }
  
  private func processTouches(with event: NSEvent) {
    // Get all touching touches (includes .began, .moved, .stationary)
    let touches = event.touches(matching: .touching, in: self)
    
    // Convert to our data model
    let trackpadTouches = Set(touches.map(TrackpadTouch.init))
    
    // Forward via delegate
    delegate?.touchesView(self, didUpdateTouches: trackpadTouches)
  }
  
  // MARK: - Touch Event Handlers
  
  public override func touchesBegan(with event: NSEvent) {
    processTouches(with: event)
  }
  
  public override func touchesMoved(with event: NSEvent) {
    processTouches(with: event)
  }
  
  public override func touchesEnded(with event: NSEvent) {
    processTouches(with: event)
  }
  
  public override func touchesCancelled(with event: NSEvent) {
    processTouches(with: event)
  }
}

// MARK: - Delegate Protocol

/// Protocol for receiving touch updates
public protocol TrackpadTouchesDelegate: AnyObject {
  /// Called when the set of touching touches changes
  func touchesView(_ view: TrackpadTouchesNSView, didUpdateTouches touches: Set<TrackpadTouch>)
}

// MARK: - SwiftUI Representable

/// SwiftUI wrapper for the trackpad touches view
public struct TrackpadTouchesView: NSViewRepresentable {
  /// Binding to the collection of current touches
  @Binding public var touches: Set<TrackpadTouch>
  
  /// Optional callback for touch updates
  private var onTouchesUpdate: ((Set<TrackpadTouch>) -> Void)?
  
  /// Initialize with a binding to touches
  public init(touches: Binding<Set<TrackpadTouch>>,
              onTouchesUpdate: ((Set<TrackpadTouch>) -> Void)? = nil) {
    self._touches = touches
    self.onTouchesUpdate = onTouchesUpdate
  }
  
  public func makeNSView(context: Context) -> TrackpadTouchesNSView {
    let view = TrackpadTouchesNSView()
    view.delegate = context.coordinator
    return view
  }
  
  public func updateNSView(_ nsView: TrackpadTouchesNSView, context: Context) {
    // No updates needed when the view parameters change
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public class Coordinator: NSObject, TrackpadTouchesDelegate {
    let parent: TrackpadTouchesView
    
    init(_ parent: TrackpadTouchesView) {
      self.parent = parent
    }
    
    public func touchesView(_ view: TrackpadTouchesNSView, didUpdateTouches touches: Set<TrackpadTouch>) {
      DispatchQueue.main.async {
        self.parent.touches = touches
        self.parent.onTouchesUpdate?(touches)
      }
    }
  }
}

// MARK: - Helper Extensions

/// Helper extension for visualization
public extension TrackpadTouch {
  /// Convert the normalized position to a point in the provided frame
  func pointInFrame(_ frame: CGRect) -> CGPoint {
    return CGPoint(
      x: position.x * frame.width,
      y: position.y * frame.height
    )
  }
}

// MARK: - Example Usage

public struct TrackpadTouchesExample: View {
  @State private var touches: Set<TrackpadTouch> = []
  
  public init() {}
  
  public var body: some View {
    ZStack {
      // Background
      Color.black.opacity(0.1)
        .edgesIgnoringSafeArea(.all)
      
      // Touch visualization
      ForEach(Array(touches), id: \.id) { touch in
        Circle()
          .fill(Color.blue.opacity(0.7))
          .frame(width: 40, height: 40)
          .position(
            x: touch.position.x * 500,
            y: touch.position.y * 500
          )
      }
      
      // Touch count indicator
      Text("Touches: \(touches.count)")
        .padding()
        .background(Color.white.opacity(0.7))
        .cornerRadius(8)
        .position(x: 100, y: 40)
      
      // The invisible touch capture view
      TrackpadTouchesView(touches: $touches)
//        .allowsHitTesting(false)
    }
  }
}

#if DEBUG

#Preview {
  TrackpadTouchesExample()
}
#endif


#endif
