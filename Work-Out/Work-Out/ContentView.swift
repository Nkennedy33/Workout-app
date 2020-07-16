//
//  ContentView.swift
//  Work-Out
//
//  Created by Nolan Kennedy on 7/14/20.
//  Copyright © 2020 Nolan Kennedy. All rights reserved.
//

import SwiftUI
import HealthKit
import HealthKitUI

let healthStore = HKHealthStore()
// The quantity type to write to the health store.
let typesToShare: Set = [
    HKQuantityType.workoutType()
]

// The quantity types to read from the health store.
let typesToRead: Set = [
    HKQuantityType.quantityType(forIdentifier: .heartRate)!,
    HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
    HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
]

// Request authorization for those quantity types.
    
healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
    // Handle error.
}
let configuration = HKWorkoutConfiguration()
configuration.activityType = .running
configuration.locationType = .outdoor
let healthStore = HKHealthStore()
var session: HKWorkoutSession!
var builder: HKLiveWorkoutBuilder!
do {
    session = try HKWorkoutSession(healthStore: healthStore, configuration: self.workoutConfiguration())
    builder = session.associatedWorkoutBuilder()
} catch {
    // Handle any exceptions.
    return
}

// Setup session and builder.
session.delegate = self
builder.delegate = self

// The cancellable holds the timer publisher.
var start: Date = Date()
var cancellable: Cancellable?
var accumulatedTime: Int = 0

// Set up and start the timer.
func setUpTimer() {
    start = Date()
    cancellable = Timer.publish(every: 0.1, on: .main, in: .default)
        .autoconnect()
        .sink { [weak self] _ in
            guard let self = self else { return }
            self.elapsedSeconds = self.incrementElapsedTime()
        }
}

// Calculate the elapsed time.
func incrementElapsedTime() -> Int {
    let runningTime: Int = Int(-1 * (self.start.timeIntervalSinceNow))
    return self.accumulatedTime + runningTime
}
struct ContentView: View {
    var body: some View {
        Text("Work-Out!")
            .font(.title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


