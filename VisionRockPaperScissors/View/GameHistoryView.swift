//
//  GameHistoryView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import SwiftUI

struct GameHistoryView: View {

  @Environment(\.dismiss) private var dismiss
  let history: [GameResult]

  var body: some View {
    NavigationStack {
      List(history.reversed()) { history in
        HStack {
          Text(history.player.emoji)
          Spacer()
          Text(history.opponent.emoji)
        }
      }
      .toolbar {
        Button {
          dismiss()
        } label: {
          Image(systemName: "xmark")
        }
      }
    }
  }

}
