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

