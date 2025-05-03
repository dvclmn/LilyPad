//
//  Representable.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

#if canImport(AppKit)
import SwiftUI
import AppKit


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


#endif
