//
//  NoteListOneToManyView.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 08/12/2024.
//

import SwiftUI
import SwiftData

struct NoteListOneToManyView: View {
    
    // MARK: - States
    @State private var isPresentingModal: Bool = false
    @State private var newItem: String = ""
    @State private var selectedCategories: [CategoryType] = []
    
    // MARK: - Queries
    @Query(FetchDescriptor(predicate: #Predicate {( note: NoteOneToMany ) in note.isDone == false }, sortBy: [SortDescriptor(\.dateTimeAdded, order: .reverse)]), animation: .snappy) private var todoNotes: [NoteOneToMany]
    
    @Query(FetchDescriptor(predicate: #Predicate {( note: NoteOneToMany ) in note.isDone == true }, sortBy: [SortDescriptor(\.dateTimeAdded, order: .reverse)]), animation: .snappy) private var doneNotes: [NoteOneToMany]
    
    // MARK: - Environment Variables
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    // Section for To-Do Notes
                    Section(header: Text("To Do")) {
                        ForEach(todoNotes, id: \.id) { note in
                            NoteRowViewOneToMany(note: note, context: context)
                        }
                    }
                    
                    // Section for Done Notes
                    Section(header: Text("Done")) {
                        ForEach(doneNotes, id: \.id) { note in
                            NoteRowViewOneToMany(note: note, context: context)
                        }
                    }
                }
            }.navigationTitle("Notes List")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add Item") {
                            isPresentingModal.toggle()
                        }
                    }
                }.sheet(isPresented: $isPresentingModal) {
                    AddItemWithMultipleCategoriesView(selectedCategories: $selectedCategories, newItem: $newItem, onSave: {
                        onSave()
                    }, onCancel: {
                        onCancel()
                    })
                }
        }
    }
    
    func onSave() {
        // Action to add a new item to the list
        if !newItem.isEmpty {
            let note = NoteOneToMany(content: newItem, isDone: false)
            let categories = selectedCategories.map { CategoryOneToMany(categoryType: CategoryType(rawValue: $0.rawValue) ?? .personal, belongsTo: note) }
            categories.forEach { context.insert($0)}
            do {
                try context.save()
            } catch {
                print("Error saving: \(error.localizedDescription)")
            }
        }
        newItem = ""
        isPresentingModal.toggle()
        selectedCategories = []
    }
    
    func onCancel() {
        isPresentingModal = false
    }
}

