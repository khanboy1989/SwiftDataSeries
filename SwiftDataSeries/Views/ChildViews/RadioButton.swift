//
//  RadioButton.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 08/12/2024.
//

import SwiftUI

struct RadioButton: View {
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Button(action: action) {
                Circle()
                    .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 2)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .fill(isSelected ? Color.blue : Color.clear)
                            .frame(width: 12, height: 12)
                    )
            }.buttonStyle(.plain)
        }
    }
}
