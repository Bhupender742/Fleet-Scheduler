//
//  SchedulingAlgorithm.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import Foundation

protocol SchedulingAlgorithm {
    func schedule(
        trucks: [Truck],
        chargers: [Charger],
        timeLimit: Int
    ) -> ScheduleResult
}

