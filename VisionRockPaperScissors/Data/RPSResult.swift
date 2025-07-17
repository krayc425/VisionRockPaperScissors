//
//  RecognitionResult.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import Foundation

enum GameOutcome {
  case win, lose, draw
}

enum RPSResult: CaseIterable {

  case rock
  case paper
  case scissor

  var emoji: String {
    switch self {
      case .rock:
        return "👊"
      case .paper:
        return "🖐"
      case .scissor:
        return "✌️"
    }
  }

  func applySkintone(_ skintone: SkinTone?) -> String {
    return emoji + (skintone ?? .none).rawValue
  }

  func beats(_ other: RPSResult) -> Bool {
    switch (self, other) {
      case (.rock, .scissor),
        (.scissor, .paper),
        (.paper, .rock):
        return true
      default:
        return false
    }
  }

  func compare(to other: RPSResult) -> GameOutcome {
    if self == other {
      return .draw
    }
    return self.beats(other) ? .win : .lose
  }

  static func makeAllCasesPreview(_ skintone: SkinTone?) -> String {
    return RPSResult.allCases.map { $0.applySkintone(skintone) }.joined()
  }

}
