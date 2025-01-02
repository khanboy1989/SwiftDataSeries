//
//  NoteItemRowView.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 17/11/2024.
//

import SwiftUI
import SwiftData

struct NoteItemRowView: View {
    let note: Note
    let isEditMode: Bool
    var onSelectionChanged: (Note) -> Void
    var onDelete: (Note) -> Void
    var onDone: (Note) -> Void
    var body: some View {
        HStack {
            if isEditMode && !note.isDone  {
                Image(systemName: note.isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(note.isSelected ? .blue : .gray)
                    .onTapGesture {
                        note.isSelected.toggle()
                        onSelectionChanged(note)
                    }
            }
            
            VStack(alignment: .leading ,spacing: 4) {
                Text(note.content)
                    .font(.headline)
                    .strikethrough(note.isDone, color: .gray)
                    .foregroundStyle(note.isDone ? .gray : .primary)
                
                Text(note.dateAdded.formatDate())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if let category = note.category {
                    Text(category.categoryTypeRawValue)
                        .font(.subheadline)
                        .padding(6)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            Spacer()
            
            if !isEditMode {
                Button {
                    toggleDoneStatus()
                } label: {
                    Image(systemName: note.isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(note.isDone ? .green : .blue)
                }.swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        onDelete(note)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
    
    private func toggleDoneStatus() {
        note.isDone.toggle()
        onDone(note)
    }
}

