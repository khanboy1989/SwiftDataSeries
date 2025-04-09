//
//  SwiftDataSeriesMigrationPlan.swift
//  SwiftDataSeries
//
//  Created by Serhan Khan on 09/04/2025.
//

import SwiftData

enum SwiftDataSeriesMigrationPlan: SchemaMigrationPlan {
    
    static var schemas: [any VersionedSchema.Type]  {
        [SwiftDataSeriesSchemaVersionV1.self, SwiftDataSeriesSchemaVersionV2.self,
        ]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(fromVersion: SwiftDataSeriesSchemaVersionV1.self, toVersion: SwiftDataSeriesSchemaVersionV2.self)
}
