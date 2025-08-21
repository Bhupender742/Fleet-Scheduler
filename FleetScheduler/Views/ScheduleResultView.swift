//
//  ScheduleResultView.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import SwiftUI

struct ScheduleResultView: View {
    let schedule: ScheduleResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Summary
            VStack(alignment: .leading, spacing: 8) {
                Text("Schedule Summary")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack {
                    Label("\(schedule.totalTrucksCharged)", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("trucks will be fully charged")
                }
                
                if !schedule.unassignedTrucks.isEmpty {
                    HStack {
                        Label("\(schedule.unassignedTrucks.count)", systemImage: "xmark.circle.fill")
                            .foregroundColor(.red)
                        Text("trucks cannot be charged in time")
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Charging Schedule
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Charging Schedule")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    let groups = groupAssignmentsByCharger()
                    
                    if !groups.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(groups, id: \.key) { chargerGroup in
                                    ChargerScheduleView(
                                        charger: chargerGroup.key,
                                        assignments: chargerGroup.value
                                    )
                                }
                            }
                        }
                    } else {
                        Text("No trucks can be scheduled for charging in the selected time frame.")
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }                
                
                // Unassigned Trucks
                if !schedule.unassignedTrucks.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Unassigned Trucks")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)

                        ScrollView {
                            ForEach(schedule.unassignedTrucks, id: \.id) { truck in
                                UnassignedTruckView(truck: truck)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - Private
private extension ScheduleResultView {
    func groupAssignmentsByCharger() -> [(key: Charger, value: [ChargingAssignment])] {
        let grouped = Dictionary(grouping: schedule.assignments) { $0.charger }
        return grouped.map { (key: $0.key, value: $0.value.sorted { $0.startTime < $1.startTime }) }
            .sorted { $0.key.id < $1.key.id }
    }
}
