//
//  NoteOneToMany.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 08/12/2024.
//

import SwiftData
import Foundation

@Model class NoteOneToMany: Identifiable {
    @Attribute(.unique) var id: UUID
    var content: String
    var isDone: Bool
    var dateTimeAdded: Date
    @Relationship(deleteRule: .cascade, inverse: \CategoryOneToMany.belongsTo) var categories: [CategoryOneToMany] = []
    
    @Transient var dateTimeAddedFormatted: String {
        return dateTimeAdded.formatDate()
    }
    
    init(content: String, isDone: Bool, dateTimeAdded: Date = Date(), categories: [CategoryOneToMany] = []) {
        self.id = UUID()
        self.content = content
        self.isDone = isDone
        self.dateTimeAdded = dateTimeAdded
        self.categories = categories
    }
}
