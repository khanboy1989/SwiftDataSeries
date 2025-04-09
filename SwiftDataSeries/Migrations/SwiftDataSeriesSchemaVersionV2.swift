//
//  SwiftDataSeriesSchemaVersionV2.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 09/04/2025.
//

import SwiftData
import Foundation

enum SwiftDataSeriesSchemaVersionV2: VersionedSchema {
    
    static var models: [any PersistentModel.Type] = [
        Note.self,
        Category.self
    ]
    
    static var versionIdentifier: Schema.Version = .init(1, 0, 1)
}

extension SwiftDataSeriesSchemaVersionV2 {
    @Model final class Note: Identifiable {
        @Attribute(.unique) var id: UUID
        var content: String
        var isDone: Bool
        @Attribute(originalName: "dateAdded")
        var dueDate: Date

        @Relationship(deleteRule: .cascade, inverse: \Category.belongsTo) var category: Category?
        
        @Transient var isSelected: Bool = false
        @Transient var formattedDate: String {
            dueDate.formatDate()
        }
        
        init(content: String, isDone: Bool, dueDate:Date = Date()) {
            self.id = UUID()
            self.content = content
            self.isDone = isDone
            self.dueDate = dueDate
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
