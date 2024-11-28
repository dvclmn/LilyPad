//
//  ViewModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 27/11/2024.
//

import SwiftUI

struct GestureValues {
  var zoom: CGFloat = 1.0
  var rotation: CGFloat = .zero
  var pan: CGPoint = .zero
}

public typealias PanOutput = (CGPoint) -> Void

public struct GestureModifier: ViewModifier {
  
  @State private var gestures: GestureValues = .init()
  
  private let isDebugMode: Bool = false
  let isModifying: Bool
  let panOutput: PanOutput
  
  public init(
//    gestures: GestureValues,
    isModifying: Bool = true,
  panOutput: @escaping PanOutput = { _ in }
  ) {
    self.isModifying = isModifying
    self.panOutput = panOutput
  }
  
  public func body(content: Content) -> some View {
    ZStack {
      content
//        .scaleEffect(gestures.zoom)
        .offset(x: isModifying ? gestures.pan.x : .zero, y: isModifying ? gestures.pan.y : .zero)
//        .rotationEffect(.degrees(gestures.rotation))
//        .drawingGroup()
      
      TrackpadGestureView { type, value in
        
        switch type {
          case .panX:
            print("Pan X: \(value)")
            self.gestures.pan.x = value

          case .panY:
            print("Pan Y: \(value)")
            self.gestures.pan.y = value
            
          default: break
        }

//        }
      } // END gesture view
      .task(id: gestures.pan) {
        self.panOutput(gestures.pan)
      }
    } // END zstack
    .frame(maxWidth: .infinity, maxHeight: .infinity)
//    .overlay(alignment: .topLeading) {
//      if isDebugMode {
//        HStack {
//          RotationDebugGauge(currentAngle: gestures.rotation)
//            .frame(width: 200)
//            .aspectRatio(1, contentMode: .fit)
//          
////          Text(gestures)
//        } // END hstack
//        .padding()
//      }
//    } // END debug overlay
  }
}
public extension View {
  func trackpadGestures() -> some View {
    self.modifier(
      GestureModifier()
    )
  }
  func panGesture(_ output: @escaping PanOutput) -> some View {
    self.modifier(
      GestureModifier(isModifying: false, panOutput: output)
    )
  }
}

