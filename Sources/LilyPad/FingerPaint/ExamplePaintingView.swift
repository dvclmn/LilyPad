//
//  Example.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import BaseHelpers
import SwiftUI

public struct TrackpadTouchesExample: View {

  @State private var debouncer = AsyncDebouncer()
  @FocusState private var isFocused: Bool
  @Binding var handler: AppHandler

  public init(
    _ handler: Binding<AppHandler>
  ) {
    self._handler = handler
  }

  public var body: some View {

    // MARK: - Touch Tracking View

    VStack(alignment: .leading) {
      TouchDebugView(handler: handler)
      TrackpadTouchesView { touches in
        if handler.touches != touches {
          handler.touches = touches
        }
        handler.processTouches()
      }
      .overlay { CanvasView(handler: handler) }
      .mouseLock($handler.isPointerLocked)
    }  // END main vstack
    .focusable(true)
    .focused($isFocused)
    .focusEffectDisabled(true)
    .padding()

    /// Overall App window sizing (nothing too technical, just indicative of logical sizing)
    .frame(
      minWidth: handler.trackPadSize.width,
      idealWidth: handler.trackPadSize.width * 1.5,
      minHeight: handler.trackPadSize.height,
      idealHeight: handler.trackPadSize.height * 1.5,
    )
    .gesture(clickDownDetection)


    .onGeometryChange(for: CGSize.self) { proxy in
      return proxy.size
    } action: { newSize in
      handler.windowSize = newSize
    }

    .onAppear {
      isFocused = true
    }

    .onKeyPress { keyPress in
      return handleKeyPress(keyPress.key)
    }

    .onAppear {
      handler.isPointerLocked = true
    }

  }
}

extension TrackpadTouchesExample {

  func handleKeyPress(_ key: KeyEquivalent) -> KeyPress.Result {
    switch key {
      case "a":
        handler.isPointerLocked.toggle()
        return .handled

      case "c":
        handler.clearStrokes()
        return .handled

      default: return .ignored
    }
  }

  var clickDownDetection: some Gesture {
    DragGesture(minimumDistance: 0)
      .onChanged { value in
        print("Began click/drag")
        print("Drag distance: \(value.translation.displayString())")
        print("Drag velocity: \(value.velocity.displayString())")
        handler.isClicked = true
      }
      .onEnded { _ in
        print("Ended drag")
        handler.isClicked = false
      }
  }

}

#if DEBUG

#Preview(traits: .fixedLayout(width: 800, height: 800)) {
  @Previewable @State var handler = AppHandler()
  TrackpadTouchesExample($handler)
  //    .offset(x: -200, y: 0)
}
#endif
