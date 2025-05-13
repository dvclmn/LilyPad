//
//  IndicatorsView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseComponents
import BaseHelpers
import BaseStyles
import SwiftUI

public struct TouchIndicatorsView: View {

  let touches: Set<TouchPoint>
  let mappingRect: CGRect

  public var body: some View {

    if touches.count > 0 {
      ForEach(touches.array) { touch in
        Circle()
          .fill(indicatorColour(touch))
          .frame(width: 40, height: 40)
          .overlay(alignment: .top) {

            /// Displays info above each individual touch location
            Text(touch.position.displayString)
              .monospaced()
              .roundedBackground(Styles.sizeNano, colour: AnyShapeStyle(.black.opacity(0.6)))
              .offset(y: -22)
              .font(.caption2)
              .fixedSize()

          }
          .position(touchPosition(touch))
      }
//      .angledLine(between: touches, mappingRect: mappingRect)
      .frame(
        width: mappingRect.width,
        height: mappingRect.height
      )
    }

  }
}

extension TouchIndicatorsView {

  func indicatorColour(_ touch: TouchPoint) -> Color {
    let matchingIdsCount = touches.filter { point in
      point.id == touch.id
    }.count
    
    // If there's more than 1 point with this ID (including this one), show red
    if matchingIdsCount > 1 {
      return .red
    }
    return Color.blue.opacity(0.7)
  }
  
//  func indicatorColour(_ touch: TouchPoint) -> Color {
//    let thing: Int = touches.count { point in
//      point.id == touch.id
//    }
//
//    guard thing < 0 else {
//      return .red
//    }
//    return Color.blue.opacity(0.7)
//  }

  func touchPosition(_ touch: TouchPoint) -> CGPoint {
    touch.position.mapped(to: mappingRect)
  }
}

#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.normal)) {
  GeometryReader { _ in
    TouchIndicatorsView(
      touches: [TouchPoint.example01, TouchPoint.example02],
      mappingRect: CGRect(x: 0, y: 0, width: 400, height: 500)
    )
  }
  .padding()
}
#endif
