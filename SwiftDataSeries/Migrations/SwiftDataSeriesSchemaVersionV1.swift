//
//  SwiftDataSeriesSchemaVersionV1.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 22/03/2025.
//

import SwiftData
import Foundation

enum SwiftDataSeriesSchemaVersionV1: VersionedSchema {
    static var models: [any PersistentModel.Type] = [
        Note.self,
        Category.self,
    ]
    
    static var versionIdentifier: Schema.Version = .init(1,0,0)
    
}

extension SwiftDataSeriesSchemaVersionV1 {
    
    @Model final class Note: Identifiable {
        @Attribute(.unique) var id: UUID
        var content: String
        var isDone: Bool
        var dateAdded: Date
        @Relationship(deleteRule: .cascade, inverse: \Category.belongsTo) var category: Category?
        
        @Transient var isSelected: Bool = false
        
        @Transient var formattedDate: String {
            dateAdded.formatDate()
        }
        
        init(content: String, isDone: Bool) {
            self.id = UUID()
            self.content = content
            self.isDone = isDone
            self.dateAdded = Date()
        }
    }

    
    @Model final class Category: Identifiable {
        @Attribute(.unique) var id: UUID
        var categoryTypeRawValue: String
        @Relationship var belongsTo: Note?
        
        init(categoryTypeRawValue: String, belongsTo: Note? = nil) {
            self.id = UUID()
            self.categoryTypeRawValue = categoryTypeRawValue
            self.belongsTo = belongsTo
        }
    }
}
