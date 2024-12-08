//
//  AddItemWithMultipleCategoriesView.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 08/12/2024.
//

import SwiftData
import SwiftUI

struct AddItemWithMultipleCategoriesView: View {
    @Binding var selectedCategories: [CategoryType]
    @Binding var newItem: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Note")) {
                    TextField("Enter new note", text: $newItem)
                        .textFieldStyle(.roundedBorder)
                }
                
                Section(header: Text("Select Categories")) {
                    ForEach(CategoryType.allCases, id: \.self) { category in
                        HStack {
                            Text(category.rawValue)
                            Spacer()
                            RadioButton(isSelected: selectedCategories.contains(category), action: {
                                
                                if selectedCategories.contains(category) {
                                    selectedCategories.removeAll { $0 == category}
                                } else {
                                    selectedCategories.append(category)
                                }
                            })
                        }
                    }
                }
            }.navigationTitle("Add Note")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            // Add save logic here
                            // Ensure newItem and selectedCategories are passed appropriately to your data model
                            onSave()
                            print("New Item: \(newItem), Categories: \(selectedCategories)")
                        }
                        .disabled(newItem.isEmpty || selectedCategories.isEmpty)
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            onCancel()
                        }
                    }
                }
        }
    }
}
