//
//  Representable.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import AppKit
import SwiftUI

// Models
public struct TrackpadTouch: Hashable, Identifiable {
  public let id: Int
  public let location: CGPoint
  
  public init(id: Int, location: CGPoint) {
    self.id = id
    self.location = location
  }
}

// NSView
public final class TrackpadTouchCaptureView: NSView {
  
  var onTouchesChanged: ((Set<TrackpadTouch>) -> Void)?
  
  public override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }
  public override var acceptsFirstResponder: Bool { true }
  
  public override func touchesBegan(with event: NSEvent) {
    handleTouches(from: event)
  }
  
  public override func touchesMoved(with event: NSEvent) {
    handleTouches(from: event)
  }
  
  public override func touchesEnded(with event: NSEvent) {
    handleTouches(from: event)
  }
  
  public override func touchesCancelled(with event: NSEvent) {
    handleTouches(from: event)
  }
  
  private func handleTouches(from event: NSEvent) {
    print("Handling touches from ", event)
    
    let allTouches = event.allTouches().filter { $0.type == .indirect }
    
    let converted: Set<TrackpadTouch> = Set(allTouches.map { touch in
      let location = convert(touch.normalizedPosition)
      return TrackpadTouch(id: ObjectIdentifier(touch.identity as AnyObject).hashValue,
                           location: location)
    })
    
    onTouchesChanged?(converted)
  }
  
  private func convert(_ point: NSPoint) -> CGPoint {
    // Flip vertically to match SwiftUI coordinate space
    CGPoint(x: point.x, y: 1.0 - point.y)
  }
}


// NSViewRepresentable
public struct TrackpadTouchView: NSViewRepresentable {
  
  @Binding var touches: Set<TrackpadTouch>
  
  public init(touches: Binding<Set<TrackpadTouch>>) {
    self._touches = touches
  }
  
  public func makeNSView(context: Context) -> TrackpadTouchCaptureView {
    let view = TrackpadTouchCaptureView()
    view.wantsLayer = true
    view.layer?.backgroundColor = NSColor.clear.cgColor
    view.onTouchesChanged = { touches in
      DispatchQueue.main.async {
        self.touches = touches
      }
    }
    return view
  }
  
  public func updateNSView(_ nsView: TrackpadTouchCaptureView, context: Context) {
    print("Ran updateNSView at \(Date().format(.timeDetailed))")
    // No need to update anything here yet
  }
}

public struct ExampleTouchesView: View {
  @State private var touches: Set<TrackpadTouch> = []
  
  public init() {
  }
  
  public var body: some View {
    ZStack {
      ForEach(Array(touches)) { touch in
        Circle()
          .fill(Color.blue)
          .frame(width: 20, height: 20)
          .position(x: touch.location.x * 500, y: touch.location.y * 500)
      }
      
      TrackpadTouchView(touches: $touches)
        .frame(width: 500, height: 500)
        .background(Color.blue.opacity(0.1))
    }
  }
}

#if DEBUG
#Preview {
  ExampleTouchesView()
}
#endif

