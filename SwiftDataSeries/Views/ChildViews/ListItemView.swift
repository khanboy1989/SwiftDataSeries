//
//  ListItemView.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 09/02/2025.
//

import SwiftUI

struct ListItemView: View {
    
    // MARK: - Properties
    let title: String
    let subtitle: String
    let category: String?
    var isDone: Bool
    var isEditMode: Bool
    @Binding var isSelected: Bool
    
    // Closures
    var onDelete: () -> Void
    var onDone: () -> Void
    
    var body: some View {
        HStack {
            if isEditMode && !isDone {
                Image(systemName: isSelected ? "checkmark.circle.fill": "circle")
                    .foregroundStyle(isSelected ? .blue: .gray)
                    .onTapGesture {
                        isSelected.toggle()
                    }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .strikethrough(isDone, color: .gray)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if let category {
                    Text(category)
                        .font(.subheadline)
                        .padding(6)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            Spacer()
            
            if !isEditMode {
                Button(action:{
                    onDone()
                }) {
                    Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(isDone ? .green  : .blue)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }.padding(.vertical, 4)
    }
}
