//
//  FleetSchedulerTests.swift
//  FleetSchedulerTests
//
//  Created by Bhupender Rawat on 20/08/25.
//

import XCTest
@testable import FleetScheduler

final class FleetSchedulingTests: XCTestCase {
    private var algorithm: SchedulingAlgorithm!
    private var sampleTrucks: [Truck]!
    private var sampleChargers: [Charger]!
    
    override func setUp() {
        super.setUp()
        algorithm = GreedyShortestTimeAlgorithm()
        
        sampleTrucks = [
            Truck(id: "T1", batteryCapacity: 100.0, currentChargePercentage: 50.0), // needs 50 kWh
            Truck(id: "T2", batteryCapacity: 80.0, currentChargePercentage: 25.0),  // needs 60 kWh
            Truck(id: "T3", batteryCapacity: 120.0, currentChargePercentage: 0.0),  // needs 120 kWh
        ]
        
        sampleChargers = [
            Charger(id: "C1", chargingRate: 50.0), // 50 kW
            Charger(id: "C2", chargingRate: 25.0), // 25 kW
        ]
    }
    
    override func tearDown() {
        algorithm = nil
        sampleTrucks = nil
        sampleChargers = nil
        super.tearDown()
    }
    
    // MARK: - Data Model Tests
    func testTruckChargeCalculations() {
        let truck = Truck(id: "Test", batteryCapacity: 100.0, currentChargePercentage: 30.0)
        
        XCTAssertEqual(truck.currentChargeAmount, 30.0, accuracy: 0.01)
        XCTAssertEqual(truck.chargeNeeded, 70.0, accuracy: 0.01)
        XCTAssertEqual(truck.timeToFullCharge(chargingRate: 35.0), 2.0, accuracy: 0.01)
    }
    
    func testTruckFullyChargedCase() {
        let truck = Truck(id: "Full", batteryCapacity: 100.0, currentChargePercentage: 100.0)
        
        XCTAssertEqual(truck.chargeNeeded, 0.0, accuracy: 0.01)
        XCTAssertEqual(truck.timeToFullCharge(chargingRate: 50.0), 0.0, accuracy: 0.01)
    }
    
    // MARK: - Algorithm Tests
    func testBasicScheduling() {
        let result = algorithm.schedule(trucks: sampleTrucks, chargers: sampleChargers, timeLimit: 5.0)
        
        // Should be able to schedule at least some trucks
        XCTAssertGreaterThan(result.totalTrucksCharged, 0)
        XCTAssertEqual(result.assignments.count, result.totalTrucksCharged)
        
        // Verify no assignment exceeds time limit
        for assignment in result.assignments {
            XCTAssertLessThanOrEqual(assignment.endTime, 5.0)
        }
    }
    
    func testEmptyInputs() {
        // Test with no trucks
        var result = algorithm.schedule(trucks: [], chargers: sampleChargers, timeLimit: 8.0)
        XCTAssertEqual(result.totalTrucksCharged, 0)
        XCTAssertTrue(result.assignments.isEmpty)
        XCTAssertTrue(result.unassignedTrucks.isEmpty)
        
        // Test with no chargers
        result = algorithm.schedule(trucks: sampleTrucks, chargers: [], timeLimit: 8.0)
        XCTAssertEqual(result.totalTrucksCharged, 0)
        XCTAssertTrue(result.assignments.isEmpty)
        XCTAssertEqual(result.unassignedTrucks.count, sampleTrucks.count)
    }
    
    func testZeroTimeLimit() {
        let result = algorithm.schedule(trucks: sampleTrucks, chargers: sampleChargers, timeLimit: 0.0)
        
        XCTAssertEqual(result.totalTrucksCharged, 0)
        XCTAssertTrue(result.assignments.isEmpty)
        XCTAssertEqual(result.unassignedTrucks.count, sampleTrucks.count)
    }
    
    func testInsufficientTime() {
        // Very short time limit that can't charge any truck fully
        let result = algorithm.schedule(trucks: sampleTrucks, chargers: sampleChargers, timeLimit: 0.1)
        
        XCTAssertEqual(result.totalTrucksCharged, 0)
        XCTAssertTrue(result.assignments.isEmpty)
        XCTAssertEqual(result.unassignedTrucks.count, sampleTrucks.count)
    }
    
    func testSufficientTimeForAll() {
        // Long time limit that should allow all trucks to charge
        let result = algorithm.schedule(trucks: sampleTrucks, chargers: sampleChargers, timeLimit: 20.0)
        
        XCTAssertEqual(result.totalTrucksCharged, sampleTrucks.count)
        XCTAssertTrue(result.unassignedTrucks.isEmpty)
    }
    
    func testSingleTruckSingleCharger() {
        let truck = [Truck(id: "Solo", batteryCapacity: 60.0, currentChargePercentage: 50.0)]
        let charger = [Charger(id: "Only", chargingRate: 30.0)]
        
        let result = algorithm.schedule(trucks: truck, chargers: charger, timeLimit: 2.0)
        
        XCTAssertEqual(result.totalTrucksCharged, 1)
        XCTAssertEqual(result.assignments.count, 1)
        XCTAssertTrue(result.unassignedTrucks.isEmpty)
        
        let assignment = result.assignments.first!
        XCTAssertEqual(assignment.truck.id, "Solo")
        XCTAssertEqual(assignment.charger.id, "Only")
        XCTAssertEqual(assignment.startTime, 0.0, accuracy: 0.01)
        XCTAssertEqual(assignment.endTime, 1.0, accuracy: 0.01) // 30 kWh / 30 kW = 1 hour
    }
    
    func testMultipleAssignmentsToSameCharger() {
        let trucks = [
            Truck(id: "Fast1", batteryCapacity: 40.0, currentChargePercentage: 50.0), // 20 kWh needed
            Truck(id: "Fast2", batteryCapacity: 40.0, currentChargePercentage: 50.0), // 20 kWh needed
        ]
        let charger = [Charger(id: "FastCharger", chargingRate: 40.0)]
        
        let result = algorithm.schedule(trucks: trucks, chargers: charger, timeLimit: 2.0)
        
        XCTAssertEqual(result.totalTrucksCharged, 2)
        
        // Sort assignments by start time to verify sequential charging
        let sortedAssignments = result.assignments.sorted { $0.startTime < $1.startTime }
        
        XCTAssertEqual(sortedAssignments[0].startTime, 0.0, accuracy: 0.01)
        XCTAssertEqual(sortedAssignments[0].endTime, 0.5, accuracy: 0.01) // 20 kWh / 40 kW = 0.5 hours
        
        XCTAssertEqual(sortedAssignments[1].startTime, 0.5, accuracy: 0.01)
        XCTAssertEqual(sortedAssignments[1].endTime, 1.0, accuracy: 0.01)
    }
    
    func testAlgorithmPrioritization() {
        let trucks = [
            Truck(id: "Slow", batteryCapacity: 100.0, currentChargePercentage: 0.0),  // 100 kWh needed
            Truck(id: "Fast", batteryCapacity: 50.0, currentChargePercentage: 50.0), // 25 kWh needed
        ]
        let charger = [Charger(id: "Charger", chargingRate: 50.0)]
        
        // Time limit allows only one truck to charge fully
        let result = algorithm.schedule(trucks: trucks, chargers: charger, timeLimit: 1.0)
        
        XCTAssertEqual(result.totalTrucksCharged, 1)
        // Should prioritize the faster-charging truck
        XCTAssertEqual(result.assignments.first?.truck.id, "Fast")
        XCTAssertEqual(result.unassignedTrucks.first?.id, "Slow")
    }
    
    // MARK: - Edge Cases
    
    func testTruckAlreadyFullyCharged() {
        let trucks = [Truck(id: "Full", batteryCapacity: 100.0, currentChargePercentage: 100.0)]
        let chargers = [Charger(id: "Charger", chargingRate: 50.0)]
        
        let result = algorithm.schedule(trucks: trucks, chargers: chargers, timeLimit: 5.0)
        
        XCTAssertEqual(result.totalTrucksCharged, 1)
        XCTAssertEqual(result.assignments.count, 1)
        
        let assignment = result.assignments.first!
        XCTAssertEqual(assignment.startTime, 0.0, accuracy: 0.01)
        XCTAssertEqual(assignment.endTime, 0.0, accuracy: 0.01)
    }
    
    func testChargerWithZeroRate() {
        let trucks = [Truck(id: "Truck", batteryCapacity: 100.0, currentChargePercentage: 50.0)]
        let chargers = [Charger(id: "BrokenCharger", chargingRate: 0.0)]
        
        // This should not crash and should handle infinite charging time gracefully
        let result = algorithm.schedule(trucks: trucks, chargers: chargers, timeLimit: 5.0)
        
        // With zero charging rate, no trucks should be scheduled
        XCTAssertEqual(result.totalTrucksCharged, 0)
        XCTAssertEqual(result.unassignedTrucks.count, 1)
    }
}

// MARK: - Performance Tests
extension FleetSchedulingTests {
    func testPerformanceWithManyTrucks() {
        // Create a large number of trucks for performance testing
        let largeTruckFleet = (1...100).map { i in
            Truck(id: "Truck_\(i)",
                  batteryCapacity: Double.random(in: 80...120),
                  currentChargePercentage: Double.random(in: 10...50))
        }
        
        let chargers = (1...10).map { i in
            Charger(id: "Charger_\(i)", chargingRate: Double.random(in: 25...60))
        }
        
        measure {
            _ = algorithm.schedule(trucks: largeTruckFleet, chargers: chargers, timeLimit: 8.0)
        }
    }
}

// MARK: - Integration Tests
extension FleetSchedulingTests {
    func testSampleDataIntegration() {
        // Test with the actual sample data used in the app
        let result = algorithm.schedule(
            trucks: SampleData.trucks,
            chargers: SampleData.chargers,
            timeLimit: 8.0
        )
        
        // Verify basic sanity of the results
        XCTAssertGreaterThanOrEqual(result.totalTrucksCharged, 0)
        XCTAssertLessThanOrEqual(result.totalTrucksCharged, SampleData.trucks.count)
        
        // Verify all assignments are valid
        for assignment in result.assignments {
            XCTAssertTrue(SampleData.trucks.contains(assignment.truck))
            XCTAssertTrue(SampleData.chargers.contains(assignment.charger))
            XCTAssertLessThanOrEqual(assignment.endTime, 8.0)
            XCTAssertGreaterThanOrEqual(assignment.startTime, 0.0)
            XCTAssertLessThanOrEqual(assignment.startTime, assignment.endTime)
        }
        
        // Verify no truck appears twice
        let assignedTruckIds = result.assignments.map { $0.truck.id }
        XCTAssertEqual(Set(assignedTruckIds).count, assignedTruckIds.count)
    }
}
