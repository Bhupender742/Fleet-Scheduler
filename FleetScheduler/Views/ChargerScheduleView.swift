//
//  ChargerScheduleView.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import SwiftUI

struct ChargerScheduleView: View {
    let charger: Charger
    let assignments: [ChargingAssignment]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(charger.id)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(charger.chargingRate, specifier: "%.0f") kW")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if assignments.isEmpty {
                Text("No trucks assigned")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(assignments, id: \.truck.id) { assignment in
                        ChargingAssignmentView(assignment: assignment)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBlue).opacity(0.1))
        .cornerRadius(8)
    }
}
