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
    
    @Environment(\.modelContext) private var context
    
    @Query(FetchDescriptor(predicate: #Predicate { (note: Note) in note.isDone == false }), animation: .snappy) private var todoNotes: [Note] = []
    
    @Query(FetchDescriptor(predicate: #Predicate { (note: Note) in note.isDone == true }), animation: .snappy) private var doneNotes: [Note] = []
    
    var body: some View {
        NavigationStack {
            List {
                DisclosureGroup("To Do") {
                    ForEach(todoNotes, id: \.id) { note in
                        HStack(alignment:.center) {
                            Text(note.content)
                            Spacer()
                            Text("\(note.dateAdded.formatDate())")
                        }.swipeActions {
                            
                            Button {
                                note.isDone.toggle()
                            } label: {
                                Image(systemName: "checkmark")
                            }.tint(.green)
                            
                            Button {
                                context.delete(note)
                                try? context.save()
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            .tint(.red)
                        }
                    }
                }
                
                DisclosureGroup("Done") {
                    ForEach(doneNotes, id: \.id) { note in
                        HStack(alignment:.center) {
                            Text(note.content)
                            Spacer()
                            Text("\(note.dateAdded.formatDate())")
                        }.swipeActions {
                            Button {
                                note.isDone.toggle()
                            } label: {
                                Image(systemName: "xmark")
                            }.tint(.red)
                            
                            Button {
                                context.delete(note)
                                try? context.save()
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            .tint(.red)
                        }
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Item") {
                        isPresentingModal = true
                    }
                }
            }.sheet(isPresented: $isPresentingModal) {
                AddItemModalView(text: $newText, onComplete: {
                    isPresentingModal = false

                    guard !newText.isEmpty else {
                        return
                    }
                    
                    context.insert(Note(content: newText, isDone: false))
                    
                    do {
                        try context.save()
                        newText = ""
                    } catch {
                        print("Error on saving = \(error.localizedDescription)")
                    }
                    
                })
            }
        }
    }
}

struct AddItemModalView: View {
    @Binding var text: String
    var onComplete: () -> Void
    
    var body: some View {
        
        NavigationView {
            VStack {
                TextField("Enter new item", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
            }.toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onComplete()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onComplete()
                    }
                }
            }
        }
        
    }
}
#Preview {
    NoteListView()
}
