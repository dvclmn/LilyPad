//
//  Model+Debug.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import SwiftUI
import BaseComponents

public enum TouchDebugItem: String, HBarItem {
  case counts
//  case strokeCountActive
//  case strokeCountCompleted
//  case strokeCountTotal
//  case pointCountFiltered
  case touchModeActive
  case pointerLocked
//  case clickedDown
  case pressure
  
  public static let itemsKey: String = "InfoBarItems"
  public static let defaultItems: Set<Self> = [
    .counts,
//    .strokeCountActive,
//    .strokeCountCompleted,
//    .strokeCountTotal,
//    .pointCountFiltered,
    .touchModeActive,
    .pointerLocked,
//    .clickedDown,
    .pressure
  ]
  
  public var id: String { self.rawValue }
  
  public var name: String {
    switch self {
      case .counts: "Counts"
//      case .touchCount: "Touch Count"
//      case .strokeCountActive: "Strokes (Active)"
//      case .strokeCountCompleted: "Strokes (Completed)"
//      case .strokeCountTotal: "Strokes (Total)"
//      case .pointCountFiltered: "Points (Filtered)"
//      case .pointCountRaw: "Points (Raw)"
      case .touchModeActive: "Touch Mode Active"
      case .pointerLocked: "Pointer Locked"
//      case .clickedDown: "Clicked Down"
      case .pressure: "Pressure"
    }
  }
  
  public var label: QuickLabel {
    return QuickLabel(self.name)
  }
}

public enum DebugCounts: String, CaseIterable, Identifiable {
  case touches
  case points
//  case pointsFiltered
  
  /// This is always the same as number of touches
//  case strokesActive
  case strokesCompleted
  
  public var id: String { rawValue }
  public var name: String {
    switch self {
      case .touches: "Touches"
      case .points: "Points"
//      case .pointsFiltered: "Points (Filtered)"
//      case .strokesActive: "Strokes (Active)"
      case .strokesCompleted: "Strokes"
    }
  }
  
}

