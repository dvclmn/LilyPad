//
//  IndicatorsView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI
import BaseHelpers
import BaseComponents
import BaseStyles

public struct TouchIndicatorsView: View {

  let touches: Set<TouchPoint>
  let mappingRect: CGRect
  
  public var body: some View {

    if touches.count > 0 {
      ForEach(touches.array) { touch in
        Circle()
          .fill(Color.blue.opacity(0.7))
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
      .angledLine(between: touches, mappingRect: mappingRect)
      .frame(
        width: mappingRect.width,
        height: mappingRect.height
      )
    }

  }
}

extension TouchIndicatorsView {
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
