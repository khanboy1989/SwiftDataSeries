//
//  AddItemModalView.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 17/11/2024.
//

import SwiftUI

struct AddItemModalView: View {
    @Binding var text: String
    @Binding var selectedCategory: CategoryType
    var onSave: () -> Void
    var onCancel: () -> Void
    var body: some View {
        
        NavigationView {
            VStack {
                TextField("Enter new item", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(CategoryType.allCases) { category in
                        Text(category.rawValue.capitalized)
                            .tag(category)
                    }
                }.pickerStyle(.wheel)
                .padding()
                
                Spacer()
                
            }.toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                    }.disabled(text.isEmpty)
                }
            }
        }
        
    }
}
