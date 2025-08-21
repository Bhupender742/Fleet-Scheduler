//
//  Truck.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import Foundation

struct Truck: Identifiable, Hashable {
    let id: String
    let batteryCapacity: Double // in kWh
    let currentChargePercentage: Double // 0-100
    
    var currentChargeAmount: Double {
        return batteryCapacity * (currentChargePercentage / 100.0)
    }
    
    var chargeNeeded: Double {
        return batteryCapacity - currentChargeAmount
    }
    
    func timeToFullCharge(chargingRate: Double) -> Double {
        return chargeNeeded / chargingRate
    }
}
