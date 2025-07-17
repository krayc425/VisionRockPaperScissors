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
  private static let emptyArray: HandDistances = [0, 0, 0, 0, 0]
  @Published var latestLeftDistances: HandDistances = [0, 0, 0, 0, 0]
  @Published var latestRightDistances: HandDistances = [0, 0, 0, 0, 0]

  var hasResults: Bool {
    return (latestLeftDistances + latestRightDistances).filter({ $0 == 0.0 }).isEmpty
  }

  private init() {
    latestLeftDistances = if let leftDistance = userDefaults.array(forKey: UserDefaultsKeys.latestLeftDistance.rawValue) as? HandDistances, !leftDistance.isEmpty {
      leftDistance
    } else {
      Self.emptyArray
    }
    latestRightDistances = if let rightDistance = userDefaults.array(forKey: UserDefaultsKeys.latestRightDistance.rawValue) as? HandDistances, !rightDistance.isEmpty {
      rightDistance
    } else {
      Self.emptyArray
    }
  }

  func updateLeftAlignmentResult(_ result: HandTrackingResult) {
    latestLeftDistances = zip(latestLeftDistances, result.distances).map { max($0, $1) }
  }

  func updateRightAlignmentResult(_ result: HandTrackingResult) {
    latestRightDistances = zip(latestRightDistances, result.distances).map { max($0, $1) }
  }

  func reset() {
    latestLeftDistances = Self.emptyArray
    latestRightDistances = Self.emptyArray
    userDefaults.removeObject(forKey: UserDefaultsKeys.latestLeftDistance.rawValue)
    userDefaults.removeObject(forKey: UserDefaultsKeys.latestRightDistance.rawValue)
  }

  func save() {
    userDefaults.set(latestLeftDistances, forKey: UserDefaultsKeys.latestLeftDistance.rawValue)
    userDefaults.set(latestRightDistances, forKey: UserDefaultsKeys.latestRightDistance.rawValue)
  }

}
