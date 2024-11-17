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
    let context: ModelContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.content)
                .font(.headline)
                .lineLimit(3)
            
            if let category = note.category?.categoryTypeRawValue {
                HStack {
                    Text("Category: ")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(category)
                        .font(.subheadline)
                        .padding(6)
                        .background(Color.blue.opacity(0.2))
                        .foregroundStyle(.primary)
                        .cornerRadius(8)
                }
            }
            
            HStack {
                Text(note.isDone ? "Done" : "To Do")
                    .font(.caption)
                    .padding()
                    .background(note.isDone ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .cornerRadius(4)
                
                Spacer()
                
                Text(note.dateAdded, format: Date.FormatStyle
                    .dateTime
                    .day().month().year()
                    .hour().minute())
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }.padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
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
    
    func toggleStatus() {
        note.isDone.toggle()
        saveChanges()
    }
    
    func deleteNote() {
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

