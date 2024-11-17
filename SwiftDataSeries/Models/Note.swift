//
//  Note.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 25/10/2024.
//

import Foundation
import SwiftData

@Model class Note: Identifiable {
    @Attribute(.unique) var id: UUID
    var content: String
    var isDone: Bool
    var dateAdded: Date
    @Relationship(deleteRule: .cascade, inverse: \Category.belongsTo) var category: Category?
    
    init(content: String, isDone: Bool) {
        self.id = UUID()
        self.content = content
        self.isDone = isDone
        self.dateAdded = Date()
    }
}
