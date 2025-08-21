//
//  GreedyShortestTimeAlgorithm.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import Foundation

final class GreedyShortestTimeAlgorithm: SchedulingAlgorithm {
    func schedule(
        trucks: [Truck],
        chargers: [Charger],
        timeLimit: Int
    ) -> ScheduleResult {
        var assignments: [ChargingAssignment] = []
        var remainingTrucks = trucks
        var chargerEndTimes: [String: Double] = [:]
        
        // Initialize charger end times
        chargers.forEach { charger in
            chargerEndTimes[charger.id] = 0.0
        }
        
        // Continue until no more trucks can be scheduled
        while !remainingTrucks.isEmpty && !chargers.isEmpty {
            var bestAssignment: ChargingAssignment?
            var bestTruckIndex = -1
            
            // Find the best truck-charger combination
            remainingTrucks.enumerated().forEach { truckIndex, truck in
                chargers.forEach { charger in
                    let startTime = chargerEndTimes[charger.id] ?? 0.0
                    let chargingTime = truck.timeToFullCharge(chargingRate: charger.chargingRate)
                    let endTime = startTime + chargingTime
                    
                    // Check if this assignment fits within time limit
                    if endTime <= Double(timeLimit) {
                        // Prioritize by shortest charging time, then by earliest completion
                        if bestAssignment == nil ||
                            chargingTime < bestAssignment!.truck.timeToFullCharge(
                                chargingRate: bestAssignment!.charger.chargingRate
                            ) ||
                            (chargingTime == bestAssignment!.truck.timeToFullCharge(
                                chargingRate: bestAssignment!.charger.chargingRate) &&
                             endTime < bestAssignment!.endTime
                            ) {
                            bestAssignment = ChargingAssignment(
                                charger: charger,
                                truck: truck,
                                startTime: startTime,
                                endTime: endTime
                            )
                            bestTruckIndex = truckIndex
                        }
                    }
                }
            }
            
            // If we found a valid assignment, add it
            if let bestAssignment {
                assignments.append(bestAssignment)
                
                // Update charger end time
                chargerEndTimes[bestAssignment.charger.id] = bestAssignment.endTime
                
                // Remove the scheduled truck
                remainingTrucks.remove(at: bestTruckIndex)
            } else {
                // No more valid assignments possible
                break
            }
        }
        
        return ScheduleResult(
            assignments: assignments,
            unassignedTrucks: remainingTrucks,
            totalTrucksCharged: assignments.count
        )
    }
}
