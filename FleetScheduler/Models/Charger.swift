//
//  Charger.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import Foundation

struct Charger: Identifiable, Hashable {
    let id: String
    let chargingRate: Double // in kW
}
