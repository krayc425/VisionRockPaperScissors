//
//  HandAlignmentView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import SwiftUI

struct HandAlignmentView: View {

  @Environment(\.openImmersiveSpace) private var openImmersiveSpace
  @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
  @Environment(\.dismissWindow) private var dismissWindow
  @StateObject private var viewModel = HandTrackingResultViewModel()
  @StateObject private var distanceManager = HandDistanceManager.shared
  @State private var isImmersiveSpacePresented: Bool = false

  var body: some View {
    VStack(spacing: 8.0) {
      Text("Hand Alignment")
        .font(.title)
      Text("Please raise your hands and make a gesture of 🖐")
        .font(.body)
      Text(distanceManager.latestLeftDistances.map { $0.formatted() }.joined(separator: ", "))
        .font(.footnote)
        .monospaced()
      Text(distanceManager.latestRightDistances.map { $0.formatted() }.joined(separator: ", "))
        .font(.footnote)
        .monospaced()
      Button {
        distanceManager.save()
        Task {
          await dismissImmersiveSpace()
          dismissWindow(id: WindowIdentifiers.handAlignment.rawValue)
        }
      } label: {
        Text("Done")
      }
      .disabled(!distanceManager.hasResults)
    }
    .onChange(of: viewModel.leftResult) { _, newValue in
      if let newValue {
        distanceManager.updateLeftAlignmentResult(newValue)
      }
    }
    .onChange(of: viewModel.rightResult) { _, newValue in
      if let newValue {
        distanceManager.updateRightAlignmentResult(newValue)
      }
    }
    .onAppear {
      Task {
        await openImmersiveSpace(id: ImmersiveSpaceIdentifiers.handTracking.rawValue)
        isImmersiveSpacePresented = true
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
