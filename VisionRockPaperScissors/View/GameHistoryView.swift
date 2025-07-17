//
//  GameHistoryView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import SwiftUI

struct GameHistoryView: View {

  @AppStorage(UserDefaultsKeys.selectedSkintone.rawValue) private var selectedToneRawValue: String = ""
  @Environment(\.dismiss) private var dismiss
  let history: [GameResult]

  var body: some View {
    NavigationStack {
      List(history.reversed()) { history in
        HStack {
          Text(history.player.applySkintone(SkinTone(rawValue: selectedToneRawValue)))
          Spacer()
          Text(history.opponent.applySkintone(SkinTone(rawValue: selectedToneRawValue)))
        }
      }
      .navigationTitle("History")
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
