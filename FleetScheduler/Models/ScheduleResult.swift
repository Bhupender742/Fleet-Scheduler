//
//  ScheduleResult.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import Foundation

struct ScheduleResult {
    let assignments: [ChargingAssignment]
    let unassignedTrucks: [Truck]
    let totalTrucksCharged: Int
    
    var chargedTrucks: [Truck] {
        return assignments.map { $0.truck }
    }
}
