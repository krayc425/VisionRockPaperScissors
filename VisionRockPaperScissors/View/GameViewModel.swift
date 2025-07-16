//
//  GameViewModel.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import Combine
import Foundation
import SwiftUI

struct GameResult: Identifiable {

  let opponent: RPSResult
  let player: RPSResult
  let timestamp: Date

  var id: Date {
    return timestamp
  }

}

enum GameStatus {

  case countdown(Int)
  case result(GameResult)

}

class GameViewModel: ObservableObject {

  @Published var status: GameStatus = .countdown(3)
  @Published var history: [GameResult] = []

  private var timer: Timer?
  private var hasResult = false
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
    guard !hasResult else {
      return
    }
    handTrackingSubscription = publisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] trackingResult in
        guard let self, !self.hasResult else {
          return
        }
        if let trackingResult, let gameResult = RPSRecognizer.classifyGesture(
          distances: trackingResult.distances,
          baseline: HandDistanceManager.shared.latestRightDistances) {
          self.hasResult = true
          let gameResult = GameResult(
            opponent: RPSResult.allCases.randomElement()!,
            player: gameResult,
            timestamp: .now)
          self.status = .result(gameResult)
          self.history.append(gameResult)
          self.reset()
        }
      }
  }

  func reset() {
    handTrackingSubscription?.cancel()
    handTrackingSubscription = nil
    timer?.invalidate()
    hasResult = false
  }

  func restart() {
    reset()
    startCountdown()
  }

}
