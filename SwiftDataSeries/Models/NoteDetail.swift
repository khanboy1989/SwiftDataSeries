//
//  NoteDetail.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 26/10/2024.
//

import SwiftData
import Foundation


@Model class NoteDetail {
    @Attribute(.unique) var id: UUID
    var detail: String

    init(detail: String) {
        self.id = UUID()
        self.detail = detail
    }
}

