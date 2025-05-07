//
//  IndicatorsView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI

public struct TouchIndicatorsView: View {

  let touches: Set<TouchPoint>
  let canvasSize: CGSize
  public var body: some View {

    ForEach(Array(touches), id: \.id) { touch in
      Circle()
        .fill(Color.blue.opacity(0.7))
        .frame(width: 40, height: 40)
        .position(touch.position.convertNormalisedToConcrete(in: canvasSize))
    }
    .frame(
      width: canvasSize.width,
      height: canvasSize.height
    )

  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.normal)) {
  TouchIndicatorsView(touches: [], canvasSize: .init(width: 700, height: 600))
}
#endif
