//
//  SinglePlayerView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import Combine
import SwiftUI

struct SinglePlayerView: View {

  @Environment(\.openImmersiveSpace) private var openImmersiveSpace
  @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
  @Environment(\.dismiss) private var dismiss
  @StateObject private var handTrackingViewModel = HandTrackingResultViewModel()
  @StateObject private var gameViewModel = GameViewModel()
  @State private var isImmersiveSpacePresented: Bool = false
  @State private var showHistoryView: Bool = false
  private var recognizer = RPSRecognizer()

  var body: some View {
    Group {
      switch gameViewModel.status {
          case .countdown(let value):
          if value == 0 {
            Text("Show your hand!")
              .font(.largeTitle)
              .onAppear {
                gameViewModel.subscribe(handTrackingViewModel.$rightResult.eraseToAnyPublisher())
              }
          } else {
            Text("Countdown... \(value)")
              .font(.largeTitle)
          }
        case .result(let result):
          VStack {
            Spacer()
            Text("You: \(result.player.emoji)")
              .font(.largeTitle)
            Text("Opponent: \(result.opponent.emoji)")
              .font(.largeTitle)
            Button {
              gameViewModel.restart()
            } label: {
              Text("Play again")
            }
            Spacer()
          }
      }
    }
    .frame(width: 600.0, height: 600.0)
    .overlay(alignment: .top) {
      GameScoreBoardView(
        playerWins: gameViewModel.history.filter({ $0.player.beats($0.opponent) }).count,
        opponentWins: gameViewModel.history.filter({ $0.opponent.beats($0.player) }).count)
      .padding()
    }
    .overlay(alignment: .topLeading) {
      Button {
        gameViewModel.reset()
        Task {
          dismiss()
        }
      } label: {
        Image(systemName: "xmark")
      }
      .padding()
    }
    .overlay(alignment: .topTrailing) {
      Button {
        showHistoryView = true
      } label: {
        Image(systemName: "clock")
      }
      .padding()
    }
    .fullScreenCover(isPresented: $showHistoryView) {
      GameHistoryView(history: gameViewModel.history)
    }
    .onAppear {
      Task {
        await openImmersiveSpace(id: ImmersiveSpaceIdentifiers.handTracking.rawValue)
        isImmersiveSpacePresented = true
        gameViewModel.startCountdown()
      }
    }
    .onDisappear {
      Task {
        if isImmersiveSpacePresented {
          await dismissImmersiveSpace()
          isImmersiveSpacePresented = false
        }
      }
    }
  }

}
