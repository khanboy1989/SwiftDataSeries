//
//  Category.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 17/11/2024.
//

import Foundation
import SwiftData

enum CategoryType: String, CaseIterable, Identifiable {
    case work = "Work"
    case personal = "Personal"
    case important = "Important"
    case travelling = "Travelling"
    case idea = "Idea"
    var id: String { rawValue }
}

@Model class Category: Identifiable {
    @Attribute(.unique) var id: UUID
    var categoryTypeRawValue: String
    @Relationship var belongsTo: Note?
    
    init(categoryTypeRawValue: String, belongsTo: Note? = nil) {
        self.id = UUID()
        self.categoryTypeRawValue = categoryTypeRawValue
        self.belongsTo = belongsTo
    }
}
