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
  func touchesView(
    _ view: TrackpadTouchesNSView,
    didUpdate eventData: TouchEventData?
  )
}

/// There may not be any touches, so this needs to be optional
public typealias TouchUpdates = (_ eventData: TouchEventData?) -> Void

// MARK: - SwiftUI Representable
/// SwiftUI wrapper for the trackpad touches view
public struct TrackpadTouchesView: NSViewRepresentable {

  let isClickEnabled: Bool
//  @Binding var isClickEnabled: Bool
  /// Callback for touch updates
  private var onTouchesUpdate: TouchUpdates?

  public init(
    isClickEnabled: Bool,
    onTouchesUpdate: TouchUpdates? = nil,
  ) {
    self.isClickEnabled = isClickEnabled
    self.onTouchesUpdate = onTouchesUpdate
  }

  public func makeNSView(context: Context) -> TrackpadTouchesNSView {
    let view = TrackpadTouchesNSView()
    view.isClickEnabled = isClickEnabled
    view.touchesDelegate = context.coordinator
    return view
  }

  public func updateNSView(_ nsView: TrackpadTouchesNSView, context: Context) {
    if nsView.isClickEnabled != self.isClickEnabled {
      nsView.isClickEnabled = self.isClickEnabled
      print("`TrackpadTouchesNSView`'s Is Click Enabled changed. Value is now: `\(nsView.isClickEnabled)`")
    }
  }

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
      didUpdate eventData: TouchEventData?
    ) {
      DispatchQueue.main.async {
//      Task { @MainActor in
//        guard let eventData else {
//          print("`TrackpadTouchesView`'s Coordinator: No event data found")
//          self.parent.onTouchesUpdate?(nil)
//          return
//        }
        self.parent.onTouchesUpdate?(eventData)
      }
    }
  }
}
#endif
