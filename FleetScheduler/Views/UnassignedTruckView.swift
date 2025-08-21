//
//  UnassignedTruckView.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import SwiftUI

struct UnassignedTruckView: View {
    let truck: Truck
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(truck.id)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Spacer()
            
            HStack {
                Text("\(truck.currentChargePercentage, specifier: "%.0f")% charged")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(truck.chargeNeeded, specifier: "%.1f") kWh needed")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemRed).opacity(0.1))
        .cornerRadius(8)
    }
}
