//
//  HandTrackingResultViewModel.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import Combine
import SwiftUI

class HandTrackingResultViewModel: ObservableObject {

  @Published var leftResult: HandTrackingResult?
  @Published var rightResult: HandTrackingResult?

  private var cancellables = Set<AnyCancellable>()

  init() {
    HandTrackingSystem.handTrackingLeftResultPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        self?.leftResult = result
      }
      .store(in: &cancellables)
    HandTrackingSystem.handTrackingRightResultPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        self?.rightResult = result
      }
      .store(in: &cancellables)
  }

  deinit {
    cancellables.forEach {
      $0.cancel()
    }
    cancellables.removeAll()
  }

}
