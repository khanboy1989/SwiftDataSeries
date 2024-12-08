//
//  SwiftDataSeriesApp.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 25/10/2024.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataSeriesApp: App {
    
    /// An object that manages an app's schema and model storage configuration.
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
            Category.self,
            NoteOneToMany.self,
            CategoryOneToMany.self
        ])
        
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("error = \(error.localizedDescription)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NoteListOneToManyView()
        }.modelContainer(sharedModelContainer)
    }
}
