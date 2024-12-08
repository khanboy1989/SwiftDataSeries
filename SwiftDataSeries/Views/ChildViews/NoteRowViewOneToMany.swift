//
//  NoteRowViewOneToMany.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 08/12/2024.
//

import SwiftUI
import SwiftData
struct NoteRowViewOneToMany: View {
    var note: NoteOneToMany
    let context: ModelContext

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Note content
            Text(note.content)
                .font(.headline)
                .lineLimit(2)
            
            // Categories associated with the note
            if !note.categories.isEmpty {
                HStack {
                    Text("Categories:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ForEach(note.categories, id: \.id) { category in
                        Text(category.categoryTypeRawValue)
                            .font(.subheadline)
                            .padding(6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            
            // Additional metadata
            HStack {
                // Status of the note
                Text(note.isDone ? "Done" : "To Do")
                    .font(.caption)
                    .padding(4)
                    .background(note.isDone ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .cornerRadius(4)
                
                Spacer()
                
                // Date and time of addition
                // Date and time of addition
                Text(note.dateTimeAddedFormatted)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            // Toggle Status Action
            Button {
                toggleStatus()
            } label: {
                Text(note.isDone ? "To Do" : "Done")
            }
            .tint(note.isDone ? .gray : .green)
            
            // Delete Action
            Button(role: .destructive) {
                deleteNote()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    // MARK: - Actions
    private func toggleStatus() {
        note.isDone.toggle()
        saveChanges()
    }
    
    private func deleteNote() {
        context.delete(note)
        saveChanges()
    }
    
    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("⚠️ Error saving changes: \(error.localizedDescription)")
        }
    }
}
