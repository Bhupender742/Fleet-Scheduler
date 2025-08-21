//
//  ChargingAssignmentView.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import SwiftUI

struct ChargingAssignmentView: View {
    let assignment: ChargingAssignment
    
    var body: some View {
        HStack {
            Text(assignment.truck.id)
                .font(.caption)
                .fontWeight(.medium)
            
            Spacer()

            Text("\(Utility.formatTime(assignment.startTime)) - \(Utility.formatTime(assignment.endTime))")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}
