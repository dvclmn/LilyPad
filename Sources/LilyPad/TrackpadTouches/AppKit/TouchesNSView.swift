//
//  TouchesNSView.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import AppKit

/// The underlying AppKit NSView that captures raw trackpad touches
public class TrackpadTouchesNSView: NSView {
  /// Delegate to forward touch events to
  weak var delegate: TrackpadTouchesDelegate?

  /// Touch manager to handle touch tracking and velocity calculation
  private let touchManager = TrackpadTouchManager()
  
  /// Minimum velocity threshold to consider when drawing (can be adjusted)
  private let minVelocityThreshold: CGFloat = 0.05
  
  public override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  private func setupView() {
    /// Only interested in trackpad touches, not direct touches
    allowedTouchTypes = [.indirect]
    /// Include stationary touches in the updates
    wantsRestingTouches = false

    /// Let's see what recognisers are here, and add/remove as neccesary
    print("Current `gestureRecognizers`: \(gestureRecognizers)")
    
  }
  
  private func processPressure(_ pressure: Float) {
    let pressureAmount = CGFloat(pressure)
    
    print("Received pressure change event: \(pressureAmount)")
    
    delegate?.touchesView(self, didUpdateTouches: [], didUpdatePressure: pressureAmount)
  }

  private func processTouches(with event: NSEvent) {
    /// Get all touching touches. `touching` matches the `began`, `moved`,
    /// or `stationary` phases of a touch.
    /// Note: Using `end` sems to break things, so don't use that
    
    guard event.type != .pressure else {
      print("Pressure should be handled elsewhere, exiting early. Event details: \(event)")
      return
    }

    let touches = event.touches(matching: [.touching], in: self)

    /// Convert to data model
    let trackpadTouches = touchManager.processTouches(
      touches,
      timestamp: event.timestamp,
      in: self
    )

    /// Forward via delegate
    delegate?.touchesView(self, didUpdateTouches: trackpadTouches, didUpdatePressure: .zero)
  }
  
  // Inside your NSView subclass
//  func makeWindowIgnoreMouseEvents(_ shouldIgnore: Bool) {
//    // Access the window that contains this view
//    guard let window = self.window else {
//      print("View is not in a window")
//      return
//    }
//    
//    // Set the ignoresMouseEvents property
////    window.ignoresMouseEvents = shouldIgnore
////    window.titlebarAppearsTransparent = true
////    window.acceptsMouseMovedEvents = true
////    window.hasTitleBar = false
////    window.mouseLocationOutsideOfEventStream
//  }

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
  
  public override func pressureChange(with event: NSEvent) {
    processPressure(event.pressure)
  }
  
  /// This didn't do anything (that I could see)
//  public override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
//    return false
//  }
  
//  public override func beginGesture(with event: NSEvent) {
//    <#code#>
//  }
  
//  public override func dataWithEPS(inside rect: NSRect) -> Data {
//    
//  }
  
//  public override func mouseDown(with event: NSEvent) {
//    print("Mouse clicked down")
//  }
//  
//  public override func mouseMoved(with event: NSEvent) {
//    print("Mouse is Moving. \nPressure: \(event.pressure). \nPosition X:\(event.absoluteX), \nY:\(event.absoluteY).")
//  }
//  
//  public override func mouseDragged(with event: NSEvent) {
//    print("Mouse is Dragging. \nPressure: \(event.pressure). \nPosition X:\(event.absoluteX), \nY:\(event.absoluteY).")
//  }
  
//  public override func viewDidMoveToWindow() {
//    super.viewDidMoveToWindow()
//    print("View moved to window")
//    makeWindowIgnoreMouseEvents(true)
//  }

}
