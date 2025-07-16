//
//  GameScoreBoardView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import Foundation
import SwiftUI

struct GameScoreBoardView: View {

  let playerWins: Int
  let opponentWins: Int

  var body: some View {
    HStack(spacing: 32) {
      VStack {
        Text("You")
          .font(.subheadline)
        Text("\(playerWins)")
          .font(.largeTitle)
          .bold()
      }
      VStack {
        Text("Opponent")
          .font(.subheadline)
        Text("\(opponentWins)")
          .font(.largeTitle)
          .bold()
      }
    }
  }

}
