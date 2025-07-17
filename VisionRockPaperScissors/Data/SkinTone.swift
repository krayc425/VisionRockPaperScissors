//
//  SkinTone.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/16/25.
//

import Foundation

enum SkinTone: String, Identifiable, Hashable, CaseIterable {

  case none = ""
  case light = "\u{1F3FB}"
  case mediumLight = "\u{1F3FC}"
  case medium = "\u{1F3FD}"
  case mediumDark = "\u{1F3FE}"
  case dark = "\u{1F3FF}"

  var preview: String {
    return RPSResult.makeAllCasesPreview(self)
  }

  var id: String {
    return rawValue
  }

  static func applySkintone(_ rpsResult: RPSResult, skinTone: SkinTone?) -> String {
    return rpsResult.emoji + (skinTone ?? .none).rawValue
  }

}
