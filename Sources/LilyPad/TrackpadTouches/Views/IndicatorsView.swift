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

  let touches: MappedTouchPoints
//  let touches: Set<TouchPoint>
//  let mappingRect: CGRect
  
  let indicatorDiameter: CGFloat = 40

  public var body: some View {

    if touches.touchCount > 0 {
      ForEach(touches.mappedTouchPoints) { touch in
        Circle()
          .fill(indicatorColour(touch))
          .frame(width: indicatorDiameter)
//          .aspectRatio(1, contentMode: .fill)
          .overlay(alignment: .bottom) {
            /// Displays info above each individual touch location
            TouchLabel(touch)
          }
//          .position(touch.position)
          .position(touches.mappedRect.origin)
      }
      //      .angledLine(between: touches, mappingRect: mappingRect)
      .frame(
        width: touches.mappedRect.width,
        height: touches.mappedRect.height
      )
//      .border(Color.orange.opacity(0.1))
      //      .background(.red.opacity(0.4))
      //      .position(mappingRect.midPoint)
    }

  }
}

extension TouchIndicatorsView {

  @ViewBuilder
  func TouchLabel(_ touch: TouchPoint) -> some View {
    TextGroup {
      Text(touch.position.displayString)
      if isDuplicateID(touch) {
        Text("\nDuplicate ID")
          .foregroundStyle(.red)
          .fontWeight(.bold)
      }
    }
    .monospaced()
    .font(.caption2)
    .fixedSize()
    .roundedBackground(Styles.sizeNano, colour: AnyShapeStyle(.black.opacity(0.6)))
    .offset(y: -indicatorDiameter * 1.15)
  }

  //  func touchLabel(_ touch: TouchPoint) -> String {

  //  }

  func isDuplicateID(_ touch: TouchPoint) -> Bool {
    let matchingIdsCount =
    touches.mappedTouchPoints.filter { point in
        point.id == touch.id
      }
      .count

    /// If there's more than 1 point with this ID (including this one), return true
    return matchingIdsCount > 1
  }

  func indicatorColour(_ touch: TouchPoint) -> Color {
    isDuplicateID(touch) ? Color.red : Color.blue.opacity(0.7)
  }

  func touchPosition(_ touch: TouchPoint) -> CGPoint {
    touch.position.mapped(to: touches.mappedRect)
  }
}

//#if DEBUG
//@available(macOS 15, iOS 18, *)
//#Preview(traits: .size(.normal)) {
//  GeometryReader { _ in
//    TouchIndicatorsView(
//      touches: [
//        TouchPoint.example01,
//        TouchPoint.topLeading,
//        TouchPoint.topTrailing,
//        TouchPoint.bottomLeading,
//        TouchPoint.bottomTrailing,
//      ],
//      mappingRect: CGRect(x: 0, y: 0, width: 400, height: 200)
//    )
//  }
//  .padding()
//}
//#endif
