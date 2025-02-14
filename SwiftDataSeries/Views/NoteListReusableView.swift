//
//  NoteListReusableView.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 09/02/2025.
//

import SwiftUI
import SwiftData

struct NoteListReusableView: View {
    // Swift Data model context for queries and other operations
    @Environment(\.modelContext) private var context
    
    @Query(FetchDescriptor(predicate: #Predicate{(note: Note) in note.isDone == false }, sortBy: [SortDescriptor(\.dateAdded)]), animation: .snappy) private var todoNotes: [Note]
    
    @Query(FetchDescriptor(predicate: #Predicate{( note: Note ) in note.isDone == true}, sortBy: [SortDescriptor(\.dateAdded)]), animation: .snappy) private var doneNotes: [Note]
    
    @State private var selectedNotes: Set<Note> = []
    @State private var isPresentingModal: Bool = false
    @State private var newItem: String = ""
    @State private var selectedCategory: CategoryType = .work
    @State private var showAlert: Bool = false
    @State private var alertType: AlertType?
    @State private var isEditMode: Bool = false
    
    private enum AlertType {
        case error
        case success
        var message: String {
            switch self {
            case .success: return "Operation completed successfully."
            case .error: return "Something went wrong. Please try again."
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: sectionHeaderForDone) {
                        ForEach(todoNotes, id: \.id) { note in
                            ListItemView(title: note.content, subtitle: note.formattedDate, category: note.category?.categoryTypeRawValue, isDone: note.isDone, isEditMode: isEditMode, isSelected:
                                            Binding(get: {
                                selectedNotes.contains(note)
                            }, set: { newValue in
                                if newValue {
                                    selectedNotes.insert(note)
                                } else {
                                    selectedNotes.remove(note)
                                }
                            }), onDelete: {
                                handleDeletion(note)
                            }, onDone: {
                                handleOnDone(note)
                            })
                        }
                    }
                    
                    Section(header: sectionHeaderForTodo) {
                        ForEach(doneNotes, id: \.id) { note in
                            ListItemView(title: note.content, subtitle: note.formattedDate, category: note.category?.categoryTypeRawValue , isDone: note.isDone, isEditMode: isEditMode, isSelected:  Binding(get: {
                                selectedNotes.contains(note)
                            }, set: { newValue in
                                if newValue {
                                    selectedNotes.insert(note)
                                } else {
                                    selectedNotes.remove(note)
                                }
                            }), onDelete: {
                                handleDeletion(note)
                            }, onDone: {
                                handleOnDone(note)
                            })
                        }
                    }
                }.scrollContentBackground(.hidden)
                    .background(Color.clear)
                
                if isEditMode {
                    HStack {
                        Button(role: .destructive) {
                            deleteSelectedNotes()
                        } label: {
                            Text("Delete Selected (\(selectedNotes.count))")
                                .padding(.leading, 8)
                        }.disabled(selectedNotes.isEmpty)
                        
                        if selectedNotes.first(where: { $0.isDone == false}) != nil {
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
            }.navigationTitle("Tasks List")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add Item") {
                            isPresentingModal.toggle()
                        }
                    }
                    
                    ToolbarItem {
                        Button(isEditMode ? "Done" : "Edit") {
                            isEditMode.toggle()
                            if !isEditMode {
                                selectedNotes.removeAll()
                                todoNotes.forEach { $0.isSelected = false }
                            }
                        }
                    }
                }
                .alert("Message", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { showAlert.toggle() }
                } message: {
                    Text(alertType?.message ?? "An unexpected error occurred.")
                }
                .sheet(isPresented: $isPresentingModal) {
                    AddItemModalView(text: $newItem, selectedCategory: $selectedCategory,
                                     onSave: {
                        onSave()
                    }, onCancel: {
                        isPresentingModal.toggle()
                    })
                }
        }
    }
    
    
    var sectionHeaderForDone: some View {
        Text("To Do")
    }
    
    var sectionHeaderForTodo: some View {
        Text("Done")
    }
    
    private func deleteSelectedNotes() {
        for note in selectedNotes {
            context.delete(note)
        }
        do {
            try context.save()
            selectedNotes.removeAll()
            showAlert(.success)
        } catch {
            showAlert(.error)
        }
    }
    
    private func markAsDoneSelectedNotes() {
        for note in selectedNotes {
            note.isDone.toggle()
        }
        do {
            try context.save()
            self.showAlert(.success)
        } catch {
            self.showAlert(.error)
        }
    }
    
    private func handleOnDone(_ note: Note) {
        note.isDone.toggle()
        
        do {
            try context.save()
        } catch {
            showAlert(.error)
        }
    }
    
    private func onSave() {
        guard !newItem.isEmpty else { return }
        
        let note = Note(content: newItem, isDone: false)
        let category = Category(categoryTypeRawValue: selectedCategory.rawValue, belongsTo: note)
        context.insert(category)
        
        do {
            try context.save()
            showAlert(.success)
        } catch {
            showAlert(.error)
        }
    }
    
    private func handleDeletion(_ note: Note) {
        context.delete(note)
        do {
            try context.save()
            showAlert(.success)
        } catch {
            showAlert(.error)
        }
    }
    
    private func showAlert(_ type: AlertType) {
        self.alertType = type
        self.showAlert = true
    }
}

#Preview {
    NoteListReusableView()
}
