//
//  MainView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import SwiftUI

struct MainView: View {

  @State private var showHandAlignmentView: Bool = false
  @State private var showSinglePlayerView: Bool = false

  var body: some View {
    VStack(alignment: .center) {
      Spacer()
      Text(RPSResult.allCases.map { $0.emoji }.joined())
        .font(.largeTitle)
      Spacer(minLength: 24.0)
      Button {
        if HandDistanceManager.shared.hasResults {
          showSinglePlayerView = true
        } else {
          showHandAlignmentView = true
        }
      } label: {
        Text("Start")
      }
      Button {
        showHandAlignmentView = true
      } label: {
        Text("Hand alignment")
      }
      Spacer()
    }
    .fullScreenCover(isPresented: $showSinglePlayerView) {
      SinglePlayerView()
    }
    .fullScreenCover(isPresented: $showHandAlignmentView) {
      HandAlignmentView()
    }
  }

}
