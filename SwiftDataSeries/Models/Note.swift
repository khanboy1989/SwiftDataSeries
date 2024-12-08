//
//  Note.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 25/10/2024.
//

import Foundation
import SwiftData

/*
 1.    .nullify
Sets the relationship to nil without deleting the related objects.
 2.    .cascade
Deletes the related objects when the owning object is deleted.
 3.    .deny
Prevents the deletion of the owning object if it has related objects.
 4.    .noAction
Takes no action when the owning object is deleted. (Useful for handling related objects manually.)
 */


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
