//
//  Model+Debug.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation

enum TouchDebugItem: String, Identifiable, CaseIterable {
  case touchCount
  case strokeCount
  case pointCount
  case touchModeActive
  case pointerLocked
  case clickedDown
  
  var id: String { self.rawValue }
  
  var name: String {
    switch self {
      case .touchCount: "Touch Count"
      case .strokeCount: "Stroke Count"
      case .pointCount: "Point Count"
      case .touchModeActive: "Touch Mode Active"
      case .pointerLocked: "Pointer Locked"
      case .clickedDown: "Clicked Down"
    }
  }
}
