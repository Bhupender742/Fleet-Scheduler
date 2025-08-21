# Fleet Charging Scheduler - iOS SwiftUI App

## Overview

This iOS app solves the fleet scheduling problem for electric mail trucks. It optimizes overnight charging to get as many trucks as possible fully charged within a specified time limit.

## Features

- **Flexible Algorithm Architecture**: Designed with a protocol-based approach to easily swap different scheduling algorithms
- **Greedy Shortest-Time Algorithm**: Currently implements a greedy algorithm that prioritizes trucks with the shortest charging time
- **Interactive SwiftUI Interface**: Clean, user-friendly interface showing the charging schedule and results
- **Comprehensive Data Display**: Shows which trucks are assigned to which chargers, timing information, and unassigned trucks

## Architecture

### Core Components

1. **Data Models**
   - `Truck`: Represents a truck with ID, battery capacity, and current charge
   - `Charger`: Represents a charger with ID and charging rate
   - `ChargingAssignment`: Represents a scheduled charging session
   - `ScheduleResult`: Contains the complete scheduling result

2. **Scheduling Algorithm**
   - `SchedulingAlgorithm` protocol: Allows easy swapping of different algorithms
   - `GreedyShortestTimeAlgorithm`: Current implementation that prioritizes fastest-charging trucks

3. **SwiftUI Views**
   - `ContentView`: Main interface with time input and schedule button
   - `ScheduleResultView`: Displays the complete scheduling results
   - `ChargerScheduleView`: Shows assignments for each charger
   - Supporting views for individual assignments and unassigned trucks

## Algorithm Details

### Current Implementation: Greedy Shortest-Time Algorithm

The algorithm works as follows:

1. **Initialization**: Track available chargers and their end times (initially 0)
2. **Iterative Assignment**: 
   - For each remaining truck, calculate charging time on each available charger
   - Find the truck-charger combination with shortest charging time that fits within the time limit
   - Assign the truck to that charger and update the charger's next available time
3. **Termination**: Continue until no more valid assignments can be made

### Algorithm Characteristics

- **Time Complexity**: O(T × C × iterations) where T = trucks, C = chargers
- **Strategy**: Prioritizes trucks that can be charged quickly, maximizing throughput
- **Strengths**: Simple, fast, good for scenarios where charging times vary significantly
- **Weaknesses**: May not be globally optimal, doesn't consider future scheduling opportunities

## Running the App

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0 or later target

## Assumptions Made

Based on the requirements, the following assumptions were made:

1. **Continuous Charging**: Once a truck starts charging, it must continue until fully charged (as specified)
2. **Instant Transitions**: Zero time required between truck swaps on chargers (as specified)
3. **Full Charge Goal**: Priority is to get trucks to 100% charge, not partial charging
4. **Real Numbers**: Time can be fractional hours (e.g., 1.5 hours)
5. **ID Format**: Truck and charger IDs are strings for flexibility
6. **UI Focus**: Emphasis on clear display of schedule for operators to follow
