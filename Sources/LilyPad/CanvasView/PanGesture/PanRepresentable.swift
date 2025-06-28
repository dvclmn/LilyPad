//
//  PanRepresentable.swift
//  Paperbark
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

//public protocol PanDelegate: AnyObject {
//  func panView(
//    _ view: PanTrackingNSView,
//    didUpdate panData: PanPhase
//  )
//}

public typealias PanGestureOutput = (PanPhase) -> Void

// MARK: - SwiftUI Representable
public struct PanGestureView: NSViewRepresentable {
  let onPanGesture: PanGestureOutput

  public init(onPanGesture: @escaping PanGestureOutput) {
    self.onPanGesture = onPanGesture
  }

  public func makeNSView(context: Context) -> PanTrackingNSView {
    let view = PanTrackingNSView { panOutput in
      onPanGesture(panOutput)
    }

    return view
  }

  public func updateNSView(_ nsView: PanTrackingNSView, context: Context) {
  }
//  public func makeCoordinator() -> Coordinator {
//    Coordinator(self)
//  }
//
//  public class Coordinator: NSObject, PanDelegate {
//    let parent: PanGestureView
//
//    init(_ parent: PanGestureView) {
//      self.parent = parent
//    }
//
//    public func panView(
//      _ view: PanTrackingNSView,
//      didUpdate panData: PanPhase
//    ) {
//      //      Task { @MainActor in
//
//      //      }
//    }
//  }
}
