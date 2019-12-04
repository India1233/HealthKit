//
//  HealthKitAssistant.swift
//  HealthKit
//
//  Created by shiga on 05/12/19.
//  Copyright © 2019 Shigas. All rights reserved.
//

import Foundation
import HealthKit

enum HealthkitSetupError: Error {
    case dataTypeNotAvailable
    case notAvailableOnDevice
}


class HealthKitAssistant {
    public class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
           guard HKHealthStore.isHealthDataAvailable() else {
               completion(false, HealthkitSetupError.notAvailableOnDevice)
               return
           }
    
           guard let stepsCount = HKObjectType.quantityType(forIdentifier: .stepCount) else {
                   completion(false, HealthkitSetupError.dataTypeNotAvailable)
                   return
           }
           
           let healthKitTypesToWrite: Set<HKSampleType> = [stepsCount,
                                                           HKObjectType.workoutType()]
           
           let healthKitTypesToRead: Set<HKObjectType> = [stepsCount,
                                                          HKObjectType.workoutType()]
           
           HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                                read: healthKitTypesToRead) { (success, error) in
                                                   completion(success, error)
           }
           
       }
    
    public class func saveSteps(stepsCountValue: Int,
                             date: Date,
                             completion: @escaping (Error?) -> Swift.Void) {
        
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            fatalError("Step Count Type is no longer available in HealthKit")
        }
        
        let stepsCountUnit:HKUnit = HKUnit.count()
        let stepsCountQuantity = HKQuantity(unit: stepsCountUnit,
                                           doubleValue: Double(stepsCountValue))
        
        let stepsCountSample = HKQuantitySample(type: stepCountType,
                                               quantity: stepsCountQuantity,
                                               start: date,
                                               end: date)
        
        HKHealthStore().save(stepsCountSample) { (success, error) in
            
            if let error = error {
                completion(error)
                print("Error Saving Steps Count Sample: \(error.localizedDescription)")
            } else {
                completion(nil)
                print("Successfully saved Steps Count Sample")
            }
        }
        
    }
}
