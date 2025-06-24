//
//  CanvasExampleView.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

//struct CanvasExampleView: View {
//
//  var body: some View {
//
//    CanvasView(zoomRange: 0.01...4.0) { _ in
//
//      Circle()
//        .fill(Color.red)
//        .frame(width: 20, height: 20)
//      //            .offset(canvasOffset.toCGSize)
//
//
//    }
//    .background(.blue.quinary)
//    //    .overlay(alignment: .bottom) {
//    //      VStack(alignment: .leading, spacing: 8) {
//    //        Text("Canvas Offset: (\(canvasOffset.x, specifier: "%.1f"), \(canvasOffset.y, specifier: "%.1f"))")
//    //        Text("Current Phase: \(currentPhase)")
//    //        Text("Total Distance: \(totalDistance, specifier: "%.1f")")
//    //      }
//    //      .padding()
//    //      .background(Color.gray.opacity(0.1))
//    //      .cornerRadius(8)
//    //    }
//
//  }
//}
//#if DEBUG
//@available(macOS 15, iOS 18, *)
//#Preview(traits: .size(.normal)) {
//  CanvasExampleView()
//}
//#endif


// MARK: - Simple Usage Example
//public struct SimpleUsageExample: View {
//  @State private var panInfo = "No pan gesture"
//
//  public init() {}
//  public var body: some View {
//    Rectangle()
//      .fill(Color.green.opacity(0.3))
//      .frame(width: 200, height: 150)
//      .onPanGesture { phase in
//        switch phase {
//          case .inactive:
//            panInfo = "Inactive"
//          case .active(let delta):
//            panInfo = "Panning: Δ(\(delta.x.displayString), \(delta.y.displayString))"
//          case .ended(let finalDelta):
//            panInfo = "Ended with final Δ(\(finalDelta.x.displayString), \(finalDelta.y.displayString))"
//          case .cancelled:
//            panInfo = "Cancelled"
//        }
//      }
//      .overlay(
//        Text(panInfo)
//          .foregroundColor(.primary)
//      )
//  }
//}
