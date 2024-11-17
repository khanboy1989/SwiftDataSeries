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
    
    @Environment(\.modelContext) private var context
    
    @Query(FetchDescriptor(predicate: #Predicate { (note: Note) in note.isDone == false }), animation: .snappy) private var todoNotes: [Note] = []
    
    @Query(FetchDescriptor(predicate: #Predicate { (note: Note) in note.isDone == true }), animation: .snappy) private var doneNotes: [Note] = []
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("To Do")) {
                    ForEach(todoNotes, id: \.id) { note in
                        NoteItemRowView(note: note, context: context)
                    }
                }
               
                Section(header: Text("Done")) {
                    ForEach(doneNotes, id: \.id) { note in
                        NoteItemRowView(note: note, context: context)
                    }
                }
               
            }.scrollContentBackground(.hidden)
                .background(.clear)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Item") {
                        isPresentingModal = true
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
}


#Preview {
    NoteListView()
}
