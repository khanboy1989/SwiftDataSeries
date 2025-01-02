//
//  NoteListView.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 25/10/2024.
//

import SwiftUI
import SwiftData

struct NoteListView: View {
    
    @State private var isPresentingModal: Bool = false
    @State private var newText: String = ""
    @State private var selectedCategory: CategoryType = .work
    @State private var isEditMode: Bool = false
    @State private var selectedNotes: Set<Note> = []
    @Environment(\.modelContext) private var context
    
    @Query(FetchDescriptor(predicate: #Predicate { (note: Note) in note.isDone == false }), animation: .snappy) private var todoNotes: [Note] = []
    
    @Query(FetchDescriptor(predicate: #Predicate { (note: Note) in note.isDone == true }), animation: .snappy) private var doneNotes: [Note] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("To Do")) {
                        ForEach(todoNotes, id: \.id) { note in
                            NoteItemRowView(note: note, isEditMode: isEditMode, onSelectionChanged: onSelectionChanged, onDelete: handleDeletion, onDone: handleDone)
                        }
                    }
                    
                    Section(header: Text("Done")) {
                        ForEach(doneNotes, id: \.id) { note in
                            NoteItemRowView(note: note, isEditMode: isEditMode, onSelectionChanged: onSelectionChanged, onDelete: handleDeletion, onDone: handleDone)
                        }
                    }
                }.scrollContentBackground(.hidden)
                    .background(.clear)
                HStack {
                    if isEditMode {
                        HStack {
                            Button(role: .destructive) {
                                deleteSelectedNotes()
                            } label: {
                                Text("Delete Selected (\(selectedNotes.count))")
                                    .padding(.leading, 8)
                            }.disabled(selectedNotes.isEmpty)
                        }
                    }
                    
                    if selectedNotes.first(where: { $0.isDone == false }) != nil {
                        Button {
                            markAsDoneSelectedNotes()
                        } label: {
                            Text("Mark As Done (\(selectedNotes.count))")
                                .foregroundStyle(.blue)
                                .padding(.trailing, 8)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Item") {
                        isPresentingModal = true
                    }
                }
                
                ToolbarItem {
                    Button(isEditMode ? "Done" : "Edit") {
                        isEditMode.toggle()
                        if isEditMode == false {
                            selectedNotes.removeAll()
                            todoNotes.forEach { $0.isSelected = false }
                        }
                    }
                }
            }.sheet(isPresented: $isPresentingModal) {
                AddItemModalView(text: $newText, selectedCategory: $selectedCategory, onSave: {
                    isPresentingModal = false
                    let note = Note(content: newText, isDone: false)
                    let category = Category(categoryTypeRawValue: selectedCategory.rawValue, belongsTo: note)
                    context.insert(category)
                    do {
                        try context.save()
                        newText = ""
                    } catch {
                        print("Error on saving = \(error.localizedDescription)")
                    }
                }, onCancel:  {
                    isPresentingModal = false
                })
            }
        }
    }
    
    private func markAsDoneSelectedNotes() {
        for note in selectedNotes {
            note.isDone.toggle()
        }
        do {
            try context.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
    
    private func deleteSelectedNotes() {
        for note in selectedNotes {
            context.delete(note)
        }
        selectedNotes.removeAll()
        do {
            try context.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
    
    private func onSelectionChanged(note: Note) {
        withAnimation {
            if note.isSelected {
                selectedNotes.insert(note)
            } else {
                selectedNotes.remove(note)
            }
        }
    }
    
    private func handleDeletion(note: Note) {
        context.delete(note)
        do {
            try context.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
    
    private func handleDone(note: Note) {
        do {
            try context.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
}


#Preview {
    NoteListView()
}
