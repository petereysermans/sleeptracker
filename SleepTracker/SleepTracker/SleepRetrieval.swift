//
//  SleepRetrieval.swift
//  SleepTracker
//
//  Created by Peter Eysermans on 18/07/2020.
//

import Foundation
import HealthKit

class SleepRetrieval {
    
    let healthStore = HKHealthStore()
    
    func retrieveSleepWithAuth(completion: @escaping (String) -> ()) {
        
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
        ])
        
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
        ])
        
        healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if success == false {
                NSLog(" Display not allowed")
            } else {
                self.retrieveSleep(completion: completion)
            }
        }
    }
    
    func retrieveSleep(completion: @escaping (String) -> ()) {
        
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let endDate = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions.strictEndDate)
        
        // first, we define the object type we want
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            // we create our query with a block completion to execute
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 200, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    return
                }
                
                var totalSeconds : Double = 0
                
                if let result = tmpResult {
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            
                            let timeInterval = sample.endDate.timeIntervalSince(sample.startDate)
                            
                            totalSeconds = totalSeconds + timeInterval
                        }
                    }
                }
                
                let result =
                    String(Int(totalSeconds / 3600)) + "h " +
                    String(Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)) + "m " +
                    String(Int(totalSeconds.truncatingRemainder(dividingBy: 3600)
                                .truncatingRemainder(dividingBy: 60))) + "s"
                
                completion(result)
            }
            
            // finally, we execute our query
            healthStore.execute(query)
        }
    }
    
}
