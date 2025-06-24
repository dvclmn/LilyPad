//
//  PanRepresentable.swift
//  Paperbark
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

public protocol PanDelegate: AnyObject {
  func panView(
    _ view: PanTrackingNSView,
    didUpdate panData: PanPhase
  )
}


// MARK: - SwiftUI Representable
public struct PanGestureView: NSViewRepresentable {
  let onPanGesture: (PanPhase) -> Void
  
  public init(onPanGesture: @escaping (PanPhase) -> Void) {
    self.onPanGesture = onPanGesture
  }
  
  public func makeNSView(context: Context) -> PanTrackingNSView {
    print("Ran `makeNSView`")
    let view = PanTrackingNSView()
    view.panDelegate = context.coordinator
    
//    view.onPanGesture = onPanGesture
    return view
  }
  
  public func updateNSView(_ nsView: PanTrackingNSView, context: Context) {
    //    print("Ran `updateNSView`")
    //    updateIfChanged(onPanGesture, into: &nsView.onPanGesture)
    //    nsView.onPanGesture = onPanGesture
  }
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public class Coordinator: NSObject, PanDelegate {
    let parent: PanGestureView
    
    init(_ parent: PanGestureView) {
      self.parent = parent
    }
    
    public func panView(
      _ view: PanTrackingNSView,
      didUpdate panData: PanPhase
    ) {
//      Task { @MainActor in
        self.parent.onPanGesture(panData)
//      }
    }
  }
}

