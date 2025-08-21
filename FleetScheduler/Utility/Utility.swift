//
//  Utility.swift
//  FleetScheduler
//
//  Created by Bhupender Rawat on 21/08/25.
//

import Foundation

final class Utility {
    class func formatTime(_ time: Double) -> String {
        let hours = Int(time)
        let minutes = Int((time - Double(hours)) * 60)
        return String(format: "%02d:%02d", hours, minutes)
    }
}
