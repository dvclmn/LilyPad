//
//  DrawingInfoBar.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI
import BaseComponents

//struct DrawingInfoBarView: View {
//  
//  @Environment(DrawingHandler.self) private var store
////  let store: DrawingHandler
//  
//  init() {
//    print("`DrawingInfoBarView` created at \(Date.now.format(.timeDetailed))")
//  }
//  
//  var body: some View {
//    
//    HBar(type: TouchDebugItem.self) { item in
//      
//      switch item {
//          
//        case .counts:
//          ForEach(DebugCounts.allCases) { count in
//            LabeledContent(count.name, value: countsValue(count).string)
//              .foregroundStyle(hasCount(count) ? .primary : .tertiary)
//              .roundedBackground(1, colour: AnyShapeStyle(Color.gray.opacity(hasCount(count) ? 0.01 : 0.06)))
//          }
//          
//        case .pressure:
//          Text(store.strokeHandler.eventData.pressure.toDecimal)
//          
//        case .pointerLocked:
//          Text(store.isPointerLocked.description)
//          
//        case .touchModeActive:
//          Text(store.isInTouchMode.description)
//          
////        case .clickedDown:
////          Text(store.isClicked.description)
//          
//      }
//      
//      //      Text(item.name)
//      //        .gridCellAnchor(.leading)
//      //      Text(valueString(item))
//      //        .gridCellAnchor(.trailing)
//      //        .fontWeight(.medium)
//      //        .monospaced()
//      //        .foregroundStyle(booleanColour(valueString(item)))
//      
//      // END switch
//    }
//    .setLayout(axis: .horizontal, size: .compact)
//    .foregroundStyle(.primary.opacity(0.8))
//    //    .backgroundConfig
//    .viewControlSize(.small)
//    
//  }
//}
//
//extension DrawingInfoBarView {
//  
//  private func hasCount(_ item: DebugCounts) -> Bool {
//    countsValue(item) > 0
//  }
//  
//  private func countsValue(_ item: DebugCounts) -> Int {
//    switch item {
//      case .touches:
//        store.strokeHandler.eventData.touches.count
//      case .points:
//        pointCount
//        
//      case .strokesActive:
//        store.strokeHandler.activeStrokes.keys.count
//        
//      case .strokesCompleted:
//        store.strokeHandler.artwork.completedStrokes.count
//        
//    }
//  }
//  
//
//  
//  var pointCount: Int {
//    let result: Int = store.strokeHandler.allStrokes
//      .reduce(0) { partialResult, stroke in
//        
//        partialResult + stroke.points.count
//      }
//    
//    return result
//  }
//  
//}
//
