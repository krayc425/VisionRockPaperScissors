//
//  HandDistanceManager.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import SwiftUI

typealias HandDistances = [Float]

class HandDistanceManager: ObservableObject {

  static let shared = HandDistanceManager()
  private let userDefaults = UserDefaults.standard

  @Published var latestLeftDistances: HandDistances = []
  @Published var latestRightDistances: HandDistances = []

  var hasResults: Bool {
    return (latestLeftDistances + latestRightDistances).filter({ $0 == 0.0 }).isEmpty 
  }

  private init() {
    latestLeftDistances = (userDefaults.array(forKey: UserDefaultsKeys.latestLeftDistance.rawValue) as? HandDistances) ?? [0,0,0,0,0]
    latestRightDistances = (userDefaults.array(forKey: UserDefaultsKeys.latestRightDistance.rawValue) as? HandDistances) ?? [0,0,0,0,0]
  }

  func updateLeftAlignmentResult(_ result: HandTrackingResult) {
    latestLeftDistances = zip(latestLeftDistances, result.distances).map { max($0, $1) }
  }

  func updateRightAlignmentResult(_ result: HandTrackingResult) {
    latestRightDistances = zip(latestRightDistances, result.distances).map { max($0, $1) }
  }

  func save() {
    userDefaults.set(latestLeftDistances, forKey: UserDefaultsKeys.latestLeftDistance.rawValue)
    userDefaults.set(latestRightDistances, forKey: UserDefaultsKeys.latestRightDistance.rawValue)
  }

}
