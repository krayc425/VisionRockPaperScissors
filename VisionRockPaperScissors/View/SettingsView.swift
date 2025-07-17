//
//  SettingsView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/16/25.
//

import ARKit
import SwiftUI

struct SettingsView: View {

  @State private var showHandAlignmentView: Bool = false
  @Environment(\.dismiss) private var dismiss
  @AppStorage(UserDefaultsKeys.selectedSkintone.rawValue) private var selectedToneRawValue: String = ""
  @AppStorage(UserDefaultsKeys.preferredHand.rawValue) private var preferredHandRawValue: String = ""

  private var selectedSkintone: Binding<SkinTone> {
      Binding<SkinTone>(
          get: { SkinTone(rawValue: selectedToneRawValue) ?? .none },
          set: { selectedToneRawValue = $0.rawValue }
      )
  }

  private var preferredHand: Binding<HandChirality> {
      Binding<HandChirality>(
          get: { HandChirality(rawValue: preferredHandRawValue) ?? .right },
          set: { preferredHandRawValue = $0.rawValue }
      )
  }

  var body: some View {
    NavigationStack {
      List {
        Section {
          Button {
            showHandAlignmentView = true
          } label: {
            Text("Hand Alignment")
          }
          .disabled(!HandTrackingProvider.isSupported)
          Picker("Skin Tone", selection: selectedSkintone) {
            ForEach(SkinTone.allCases) { tone in
              Text(tone.preview).tag(tone)
            }
          }
          Picker("Preferred Hand", selection: preferredHand) {
            ForEach(HandChirality.allCases) { chirality in
              Text(chirality.rawValue.capitalized).tag(chirality)
            }
          }
        } footer: {
          Text("Made with ❤️ by [Kuixi Song](https://kuixisong.one)")
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
      }
      .navigationTitle("Settings")
      .fullScreenCover(isPresented: $showHandAlignmentView) {
        HandAlignmentView()
      }
      .toolbar {
        Button {
          dismiss()
        } label: {
          Image(systemName: "xmark")
        }
      }
    }
  }

}

#Preview {
  SettingsView()
}
