//
//  FleetSchedulingViewModel.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import Foundation

final class FleetSchedulingViewModel: ObservableObject {
    @Published var trucks: [Truck]
    @Published var chargers: [Charger]
    @Published var timeLimit: Int
    @Published var currentSchedule: ScheduleResult?
    private var algorithm: SchedulingAlgorithm
    
    init(
        trucks: [Truck] = [],
        chargers: [Charger] = [],
        timeLimit: Int = 8,
        algorithm: SchedulingAlgorithm = GreedyShortestTimeAlgorithm()
    ) {
        self.trucks = trucks
        self.chargers = chargers
        self.timeLimit = timeLimit
        self.algorithm = algorithm
    }
    
    func generateSchedule() {
        currentSchedule = algorithm.schedule(
            trucks: trucks,
            chargers: chargers,
            timeLimit: timeLimit
        )
    }
}
