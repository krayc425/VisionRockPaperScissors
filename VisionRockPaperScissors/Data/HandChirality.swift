//
//  HandChirality.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/16/25.
//

import Foundation

enum HandChirality: String, Hashable, Equatable, Identifiable, CaseIterable {

  case left
  case right

  var id: String {
    return rawValue
  }

}
