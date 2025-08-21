//
//  ContentView.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 20/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FleetSchedulingViewModel(
        trucks: SampleData.trucks,
        chargers: SampleData.chargers
    )

    @State private var showScheduleResult = false
    @FocusState private var isTimeLimitFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 16) {
                    Text("Fleet Charging Scheduler")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Optimize overnight charging for electric mail trucks")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Time Limit Input
                HStack {
                    Text("Time Limit:")
                        .font(.headline)

                    Spacer()

                    TextField(
                        "Hours",
                        value: $viewModel.timeLimit,
                        format: .number
                    )
                    .textFieldStyle(
                        RoundedBorderTextFieldStyle()
                    )
                    .frame(width: 80)
                    .keyboardType(.numberPad)
                    .focused($isTimeLimitFieldFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isTimeLimitFieldFocused = false
                            }
                        }
                    }

                    Text("hours")
                }
                .padding(.horizontal)

                // Schedule Button
                Button("Generate Schedule") {
                    showScheduleResult = true
                    isTimeLimitFieldFocused = false
                    viewModel.generateSchedule()
                }
                .buttonStyle(.borderedProminent)
                .font(.headline)
                .sheet(isPresented: $showScheduleResult) {
                    if let schedule = viewModel.currentSchedule {
                        ScheduleResultView(schedule: schedule)
                    } else {
                        Text("No schedule available")
                    }
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    ContentView()
}
