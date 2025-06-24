//
//  TrackpadShapeGuide.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

struct TrackpadShapeGuide: View {
  private let rounding: CGFloat = 20
  
  let containerSize: CGSize
  let mappingStrategy: TrackpadMapStrategy
  //  let trackpadSize: CGSize
  public var body: some View {
    
    ZStack(alignment: .topLeading) {
      /// This is full-bleed, full width and height
      Color.gray.opacity(0.02)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      /// This is the trackpad-sized cut-out
      RoundedRectangle(cornerRadius: rounding)
        .blendMode(.destinationOut)
      /// Trackpad width and height
        .overlay {
          /// This just handles the stroke around the trackpad cut-out
          RoundedRectangle(cornerRadius: rounding)
            .fill(.clear)
            .strokeBorder(.gray.opacity(0.06), style: .simple01)
        }
        .frame(
          width: mappingStrategy.size(for: containerSize).width,
          height: mappingStrategy.size(for: containerSize).height
        )
        .position(containerSize.midpoint)
      
    }
    .compositingGroup()
    .allowsHitTesting(false)
    
  }
}
