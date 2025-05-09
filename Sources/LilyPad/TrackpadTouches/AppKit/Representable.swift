//
//  Representable.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

#if canImport(AppKit)
import SwiftUI

// MARK: - Delegate Protocol
/// Protocol for receiving touch updates
public protocol TrackpadTouchesDelegate: AnyObject {
  func touchesView(_ view: TrackpadTouchesNSView, didUpdate eventData: TouchEventData)
}

public typealias TouchUpdates = (_ eventData: TouchEventData) -> Void

// MARK: - SwiftUI Representable
/// SwiftUI wrapper for the trackpad touches view
public struct TrackpadTouchesView: NSViewRepresentable {

  /// Callback for touch updates
  private var onTouchesUpdate: TouchUpdates?

  public init(
    onTouchesUpdate: TouchUpdates? = nil,
  ) {
    self.onTouchesUpdate = onTouchesUpdate
  }

  public func makeNSView(context: Context) -> TrackpadTouchesNSView {
    let view = TrackpadTouchesNSView()
    view.delegate = context.coordinator
    return view
  }

  public func updateNSView(_ nsView: TrackpadTouchesNSView, context: Context) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public class Coordinator: NSObject, TrackpadTouchesDelegate {
    let parent: TrackpadTouchesView

    init(_ parent: TrackpadTouchesView) {
      self.parent = parent
    }

    public func touchesView(
      _ view: TrackpadTouchesNSView,
      didUpdate eventData: TouchEventData
    ) {
      Task { @MainActor in
        self.parent.onTouchesUpdate?(eventData)
//        self.parent.onPressureUpdate?(pressure)
      }
    }
  }
}
#endif
