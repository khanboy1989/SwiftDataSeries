//
//  SwiftDataSeriesApp.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 25/10/2024.
//

import SwiftUI
import SwiftData

// MARK: SwiftData Models
typealias Note = SwiftDataSeriesSchemaVersionV2.Note
typealias Category = SwiftDataSeriesSchemaVersionV2.Category

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
        
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false /* For caching purposes, isStoredInMemoryOnly is useful when you want to avoid writing data to disk to reduce I/O operations or improve performance, especially for frequently accessed or temporary data. */)
        
        do {
            return try ModelContainer(for: schema,
                                      migrationPlan: SwiftDataSeriesMigrationPlan.self,
                                      configurations: [configuration])
        } catch {
            fatalError("error = \(error.localizedDescription)")
        }
    }()

    var body: some Scene {
        WindowGroup {
//            NoteListView()
            NoteListReusableView()
        }.modelContainer(sharedModelContainer)
    }
}
 
