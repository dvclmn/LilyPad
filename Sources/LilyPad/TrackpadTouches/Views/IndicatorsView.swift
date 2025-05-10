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

  let touches: [TouchPoint]
  let mappingRect: CGRect
  
  public var body: some View {

    ForEach(touches) { touch in
      Circle()
        .fill(Color.blue.opacity(0.7))
        .frame(width: 40, height: 40)
        .overlay(alignment: .top) {
          Text(touch.position.displayString)
            .monospaced()
            .roundedBackground(Styles.sizeNano, colour: AnyShapeStyle(.black.opacity(0.6)))
            .offset(y: -22)
            .font(.caption2)
            .fixedSize()
        }
        .position(touchPosition(touch))
    }
    .angledLine(from: firstTwoPoints.0, to: firstTwoPoints.1)
    .frame(
      width: mappingRect.width,
      height: mappingRect.height
    )

  }
}

extension TouchIndicatorsView {
  
  typealias PointPair = (CGPoint, CGPoint)
  
  var firstTwoPoints: PointPair {
    let fallback: PointPair = (.zero, .zero)
    
    guard touches.count >= 2 else {
      return fallback
    }
    let p1 = touches[0].position.mapped(to: mappingRect)
    let p2 = touches[1].position.mapped(to: mappingRect)
    
    return (p1, p2)
    
  }
  
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
