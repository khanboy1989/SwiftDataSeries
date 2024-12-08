//
//  CategoryOneToMany.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 08/12/2024.
//

import SwiftData
import Foundation

@Model class CategoryOneToMany: Identifiable {
    @Attribute(.unique) var id: UUID
    var categoryTypeRawValue: String
    @Relationship var belongsTo: NoteOneToMany? = nil
    
    init(categoryType: CategoryType, belongsTo: NoteOneToMany? = nil) {
        self.id = UUID()
        self.categoryTypeRawValue = categoryType.rawValue
        self.belongsTo = belongsTo
    }
}
