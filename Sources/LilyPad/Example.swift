//
//  Example.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import BaseHelpers
import SwiftUI

public struct TrackpadTouchesExample: View {
  @Binding var handler: TouchHandler
  @FocusState private var isFocused: Bool
  
  @State private var debouncer = AsyncDebouncer()

//  @State private var strokeHandler = StrokePathBuilder()
  
  public init(
    _ handler: Binding<TouchHandler>
  ) {
    self._handler = handler
  }

  public var body: some View {

    // Tracking view
    TrackpadTouchesView(touches: $handler.touches)
      .frame(
        minWidth: handler.trackPadSize.width,
        idealWidth: handler.trackPadSize.width * 1.5,
        minHeight: handler.trackPadSize.height,
        idealHeight: handler.trackPadSize.height * 1.5,
      )
      .gesture(clickDownDetection)

      .overlay {
        Interface()
      }
      .mouseLock($handler.isPointerLocked)

      .onGeometryChange(for: CGSize.self) { proxy in
        return proxy.size
      } action: { newSize in
        handler.windowSize = newSize
      }

      .onAppear {
        handler.isPointerLocked = true
      }
      .task(id: handler.touches) {
        handler.processTouches()
//        await debouncer.execute { @MainActor in
//        }
      }

  }
}

extension TrackpadTouchesExample {

  func booleanColour(_ value: String) -> Color {
    switch value {
      case "true": Color.orange
      case "false": Color.red
      default: Color.gray
    }
  }

  func valueString(_ item: TouchDebugItem) -> String {
    switch item {
      case .pointerLocked: handler.isPointerLocked.description
      case .touchModeActive: handler.isInTouchMode.description
      case .clickedDown: handler.isClicked.description
      case .touchCount: handler.touches.count.string
    }
  }

  @ViewBuilder
  func Interface() -> some View {

    ZStack {
      // Debug items
//      Grid {
//        ForEach(TouchDebugItem.allCases) { item in
//          GridRow {
//            Text(item.name)
//              .gridCellAnchor(.leading)
//            Text(valueString(item))
//              .gridCellAnchor(.trailing)
//              .fontWeight(.medium)
//              .monospaced()
//              .foregroundStyle(booleanColour(valueString(item)))
//          }
//          Divider()
//            .gridCellUnsizedAxes(.horizontal)
//        }
//      }
//      .padding()
//      .background(.black.opacity(0.7))
//      .clipShape(.rect(cornerRadius: 6))


      // Background representing the trackpad shape
//      Color.white.opacity(0.1)
      Canvas { context, size in
        // Draw all strokes
        for stroke in handler.allStrokes {
          let path = handler.smoothPath(for: stroke)
          //          let offSetPath = path.offsetBy(dx: 200, dy: 200)
          context.stroke(
            path,
            with: .color(stroke.color),
            style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
          )
        }
      }
        .focused($isFocused)
        .focusEffectDisabled()
        .focusable(true)
        //        .contentShape(RoundedRectangle(cornerRadius: 20))
        .frame(
          width: handler.trackPadSize.width,
          height: handler.trackPadSize.height
        )
        .onAppear {
          isFocused = true
        }
        .onKeyPress("a") {
          handler.isPointerLocked.toggle()
          return .handled
        }
        .onKeyPress("c") {
          handler.clearStrokes()
          return .handled
        }

      //        .border(Color.green.opacity(0.3))
//      .background(.pink.opacity(0.2))

      if handler.isInTouchMode {
        // Visualise Touches
        ForEach(Array(handler.touches), id: \.id) { touch in
          Circle()
            .fill(Color.blue.opacity(0.7))
            .frame(width: 40, height: 40)
            .position(
              x: handler.touchPosition(touch).x,
              y: handler.touchPosition(touch).y
            )
        }
      }
    }
    .clipShape(.rect(cornerRadius: 20))
    .allowsHitTesting(false)
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
  @Previewable @State var handler = TouchHandler()
  TrackpadTouchesExample($handler)
//    .offset(x: -200, y: 0)
}
#endif


//
//#if canImport(AppKit)
//import SwiftUI
//import AppKit
//
//// MARK: - Touch Trail Visualization Example
//
///// A touch with trail history
//public struct TouchWithTrail: Identifiable {
//  public var id: Int
//  public var currentPosition: CGPoint
//  public var trail: [CGPoint]
//  public var color: Color
//
//  public init(from touch: TrackpadTouch) {
//    self.id = touch.id
//    self.currentPosition = touch.position
//    self.trail = [touch.position]
//
//    // Generate a stable color based on the touch ID
//    let hue = CGFloat(abs(touch.id.hashValue % 20)) / 20.0
//    self.color = Color(hue: Double(hue), saturation: 0.8, brightness: 0.9)
//  }
//
//  /// Update with a new position, maintaining trail history
//  mutating func update(with newTouch: TrackpadTouch, maxTrailLength: Int = 20) {
//    currentPosition = newTouch.position
//    trail.append(newTouch.position)
//
//    // Limit trail length
//    if trail.count > maxTrailLength {
//      trail.removeFirst(trail.count - maxTrailLength)
//    }
//  }
//}
//
///// View that displays touch trails
//public struct TouchTrailView: View {
//  @State private var touches: Set<TrackpadTouch> = []
//  @State private var touchTrails: [Int: TouchWithTrail] = [:]
//
//  // Configuration
//  private let maxTrailLength = 20
//  private let fadeTrail = true
//
//  public init() {}
//
//  public var body: some View {
//    ZStack {
//      // Background
//      Color.black
//        .edgesIgnoringSafeArea(.all)
//
//      // Draw trails for each touch
//      ForEach(touchTrails.keys, id: \.self) { touchTrail in
////      ForEach(touchTrails, id: \.self) { touchTrail in
//        // Draw the trail as a path
//        if touchTrail.trail.count > 1 {
//          Path { path in
//            path.move(to: touchTrail.trail.first!)
//
//            for point in touchTrail.trail.dropFirst() {
//              path.addLine(to: point)
//            }
//          }
//          .stroke(
//            touchTrail.color,
//            style: StrokeStyle(
//              lineWidth: 3,
//              lineCap: .round,
//              lineJoin: .round
//            )
//          )
//          .opacity(fadeTrail ? 0.7 : 1.0)
//          .animation(.easeOut(duration: 0.2), value: touchTrail.trail)
//        }
//
//        // Draw the current touch point
//        Circle()
//          .fill(touchTrail.color)
//          .frame(width: 24, height: 24)
//          .position(
//            touchTrail.currentPosition.scaled(to: CGSize(width: 500, height: 500))
//          )
//      }
//
//      // The invisible touch capture view
//      GeometryReader { geometry in
//        TrackpadTouchesView(touches: $touches) { updatedTouches in
//          processTouches(updatedTouches, in: geometry.size)
//        }
//        .allowsHitTesting(false)
//      }
//
//      // Info overlay
//      VStack {
//        Spacer()
//
//        Text("Active touches: \(touchTrails.count)")
//          .font(.headline)
//          .padding()
//          .background(Color.white.opacity(0.2))
//          .cornerRadius(10)
//          .padding()
//      }
//    }
//  }
//
//  private func processTouches(_ updatedTouches: Set<TrackpadTouch>, in size: CGSize) {
//    // Create a mutable copy of the current trails
//    var updatedTrails = touchTrails
//
//    // Process each new touch
//    for touch in updatedTouches {
//      if let existingTrail = updatedTrails[touch.id] {
//        // Update existing trail
//        var trail = existingTrail
//        trail.update(with: touch, maxTrailLength: maxTrailLength)
//        updatedTrails[touch.id] = trail
//      } else {
//        // Create new trail
//        updatedTrails[touch.id] = TouchWithTrail(from: touch)
//      }
//    }
//
//    // Remove trails for touches that are no longer present
//    let currentIds = Set(updatedTouches.map { $0.id })
//    for id in updatedTrails.keys where !currentIds.contains(id) {
//      updatedTrails.removeValue(forKey: id)
//    }
//
//    // Update the state
//    touchTrails = updatedTrails
//  }
//}
//
//// MARK: - Helper Extensions
//
//extension CGPoint {
//  /// Scale normalized point (0-1) to the given size
//  func scaled(to size: CGSize) -> CGPoint {
//    return CGPoint(
//      x: self.x * size.width,
//      y: self.y * size.height
//    )
//  }
//}
//
//// MARK: - Preview Provider
//
//struct TouchTrailView_Previews: PreviewProvider {
//  static var previews: some View {
//    TouchTrailView()
//      .frame(width: 600, height: 400)
//  }
//}
//#endif
