//
//  MainView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import SwiftUI

struct MainView: View {

  @Environment(\.openWindow) var openWindow

  var body: some View {
    VStack(alignment: .center) {
      Spacer()
      Text(RPSResult.allCases.map { $0.emoji }.joined())
        .font(.largeTitle)
      Spacer(minLength: 24.0)
      Button {
        if HandDistanceManager.shared.hasResults {
          openWindow(id: WindowIdentifiers.singlePlayer.rawValue)
        } else {
          openWindow(id: WindowIdentifiers.handAlignment.rawValue)
        }
      } label: {
        Text("Start")
      }
      Button {
        openWindow(id: WindowIdentifiers.handAlignment.rawValue)
      } label: {
        Text("Hand alignment")
      }
      Spacer()
    }
  }

}
