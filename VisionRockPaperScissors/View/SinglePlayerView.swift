//
//  SinglePlayerView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import Combine
import SwiftUI

struct GameResult {

  let opponent: RPSResult
  let player: RPSResult
  let timestamp: Date
}

enum GameStatus {

  case countdown(Int)
  case result(GameResult)

}

class GameViewModel: ObservableObject {

  @Published var status: GameStatus = .countdown(3)
  @Published var history: [GameResult] = []

  private var timer: Timer?
  private var handTrackingSubscription: AnyCancellable?

  func startCountdown() {
    status = .countdown(3)

    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] t in
      guard let self = self else {
        return
      }
      switch self.status {
        case .countdown(let value) where value > 1:
          self.status = .countdown(value - 1)
        case .countdown:
          self.status = .countdown(0)
          t.invalidate()
        case .result:
          t.invalidate()
      }
    }
  }

  func subscribe(_ publisher: AnyPublisher<HandTrackingResult?, Never>) {
    handTrackingSubscription = publisher.sink { [weak self] trackingResult in
      guard let self else {
        return
      }
      if let trackingResult, let gameResult = RPSRecognizer.classifyGesture(
        distances: trackingResult.distances,
        baseline: HandDistanceManager.shared.latestRightDistances) {
        let gameResult = GameResult(
          opponent: RPSResult.allCases.randomElement()!,
          player: gameResult,
          timestamp: .now)
        self.status = .result(gameResult)
        self.history.append(gameResult)
        reset()
      }
    }
  }

  func reset() {
    handTrackingSubscription?.cancel()
    handTrackingSubscription = nil
    timer?.invalidate()
  }

  func restart() {
    reset()
    startCountdown()
  }

}

struct SinglePlayerView: View {

  @Environment(\.openImmersiveSpace) private var openImmersiveSpace
  @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
  @Environment(\.dismissWindow) private var dismissWindow
  @State private var isImmersiveSpacePresented: Bool = false
  @StateObject private var viewModel = HandTrackingResultViewModel()
  @StateObject private var gameViewModel = GameViewModel()
  private var recognizer = RPSRecognizer()

  var body: some View {
    Group {
      switch gameViewModel.status {
          case .countdown(let value):
          if value == 0 {
            Text("Show your hand!")
              .font(.largeTitle)
              .onAppear {
                gameViewModel.subscribe(viewModel.$rightResult.eraseToAnyPublisher())
              }
          } else {
            Text("Countdown... \(value)")
              .font(.largeTitle)
          }
        case .result(let result):
          VStack {
            Spacer()
            Text("You: \(result.player.emoji)")
              .font(.title)
            Text("Opponent: \(result.opponent.emoji)")
              .font(.title)
            Spacer(minLength: 24.0)
            Button {
              gameViewModel.restart()
            } label: {
              Text("Play again")
            }
            Spacer()
          }
      }
    }
    .frame(width: 800.0, height: 800.0)
    .overlay(alignment: .topLeading) {
      Button {
        gameViewModel.reset()
        Task {
          dismissWindow(id: WindowIdentifiers.singlePlayer.rawValue)
        }
      } label: {
        Image(systemName: "xmark")
      }
      .padding()
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
