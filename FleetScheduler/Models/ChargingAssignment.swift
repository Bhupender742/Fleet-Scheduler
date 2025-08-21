//
//  ChargingAssignment.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import Foundation

struct ChargingAssignment {
    let charger: Charger
    let truck: Truck
    let startTime: Double
    let endTime: Double

    var duration: Double {
        return endTime - startTime
    }
}
