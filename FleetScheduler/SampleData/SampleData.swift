//
//  SampleData.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import Foundation

final class SampleData {
    static let trucks = [
        Truck(id: "Truck 1", batteryCapacity: 100, currentChargePercentage: 20),
        Truck(id: "Truck 2", batteryCapacity: 120, currentChargePercentage: 15),
        Truck(id: "Truck 3", batteryCapacity: 90, currentChargePercentage: 30),
        Truck(id: "Truck 4", batteryCapacity: 110, currentChargePercentage: 10),
        Truck(id: "Truck 5", batteryCapacity: 95, currentChargePercentage: 25)
    ]
    
    static let chargers = [
        Charger(id: "Charger 1", chargingRate: 50),
        Charger(id: "Charger 2", chargingRate: 30),
        Charger(id: "Charger 3", chargingRate: 40)
    ]
}
