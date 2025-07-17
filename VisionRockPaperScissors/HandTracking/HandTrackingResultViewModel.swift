//
//  HandTrackingResultViewModel.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import ARKit
import Combine
import SwiftUI

class HandTrackingResultViewModel: ObservableObject {

  @Published var leftResult: HandTrackingResult?
  @Published var rightResult: HandTrackingResult?
  @Published var isAuthorized: Bool = false

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
    Task { @MainActor in
      let authorizationStatus = await HandTrackingSystem.arSession.queryAuthorization(for: [.handTracking])
      self.isAuthorized = authorizationStatus[.handTracking] == .allowed
    }
  }

  func monitorSessionEvents() async {
    for await event in HandTrackingSystem.arSession.events {
      switch event {
        case .authorizationChanged(let type, let status):
          if type == .handTracking && status != .allowed {
            isAuthorized = false
          }
        default:
          break
      }
    }
  }

  deinit {
    cancellables.forEach {
      $0.cancel()
    }
    cancellables.removeAll()
  }

}
