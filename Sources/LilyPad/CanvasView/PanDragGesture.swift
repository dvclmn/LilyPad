//
//  PanDragGesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

public typealias DragChanged = (_ gestureValue: DragGesture.Value, _ initial: CGPoint) -> Void
public typealias DragEnded = (_ gestureValue: DragGesture.Value, _ initial: CGPoint) -> CGPoint

public struct DragGestureModifier: ViewModifier {

  @State private var initialDragLocation: CGPoint = .zero
  @GestureState private var dragOffset: CGSize = .zero

  let isEnabled: Bool
  let onDragChanged: DragChanged
  let onDragEnded: DragEnded

  public func body(content: Content) -> some View {
    content
      .simultaneousGesture(makeConditionalDragGesture, isEnabled: isEnabled)
  }
}
extension DragGestureModifier {

  var makeConditionalDragGesture: some Gesture {
    DragGesture(minimumDistance: 0)
      .updating($dragOffset) { value, state, _ in
        state = value.translation
      }
      .onChanged { value in
        onDragChanged(value, initialDragLocation)
      }
      .onEnded { value in
        initialDragLocation = onDragEnded(value, initialDragLocation)
      }
  }
}
extension View {
  public func dragItemGesture(
    isEnabled: Bool,
    onDragChanged: @escaping DragChanged,
    onDragEnded: @escaping DragEnded,
  ) -> some View {
    self.modifier(
      DragGestureModifier(
        isEnabled: isEnabled,
        onDragChanged: onDragChanged,
        onDragEnded: onDragEnded
      )
    )
  }
}
