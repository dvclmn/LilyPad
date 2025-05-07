//
//  ZoomView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseHelpers
import SwiftUI

public struct ZoomView<Content: View>: View {

  @State private var store = ZoomHandler()

  let canvasSize: CGSize
  let content: Content

  public init(
    canvasSize: CGSize,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.canvasSize = canvasSize
    self.content = content()
  }

  public var body: some View {

    ZStack {

      content
        .touches(canvasSize: canvasSize) { touches, pressure in
          return print(touches)
        }
//        .overlay {
//          Rectangle()
//            .fill(.gray.opacity(0.2))
//            .clipShape(.rect(cornerRadius: 20))
//            .frame(
//              width: canvasSize.width,
//              height: canvasSize.height
//            )
//        }

    }


  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.narrow)) {
  ZoomView(canvasSize: CGSize.init(width: 400, height: 300)) {
    Text(TestStrings.paragraphs[5])
  }
  .padding(40)
  .frame(width: 600, height: 700)
  .background(.black.opacity(0.6))
}
#endif
