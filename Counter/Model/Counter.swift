//
//  Counter.swift
//  Counter
//
//  Created by Tudor Croitoru on 25/05/2019.
//  Copyright © 2019 Tudor Croitoru. All rights reserved.
//

import Foundation

class Counter: Codable {
    
    var title: String
    var initialVal = 0
    var count = 0
    var direction = 1 // 1 or -1. Either we go up, or we go down
    
    init(title: String, direction: Int, initialVal: Int) {
        self.title      = title
        self.direction  = direction
        self.initialVal = initialVal
    }
    
    
    func primaryGesture(completion: (()->(Void))?) {
        count += direction
        completion?()
    }
    
    func secondaryGesture(completion: (()->())?) {
        count += (-1 * direction)
        completion?()
    }
    
    func updateInitialVal(with value: Int) {
        initialVal = value
    }
    
    func getTotalCount() -> Int {
        return initialVal + count
    }
    
    static func getAllCountersFromDefaults() -> [Counter] {
        
        do {
            if let countersObject = defaults?.object(forKey: countersKey) as? Data {
                return try PropertyListDecoder().decode([Counter].self, from: countersObject)
            }
        } catch {
            print(error)
            return []
        }
        
        return []
    }
    
    static func writeCounterArrayToDefaults(counters: [Counter]) {
        do {
            defaults?.set(try PropertyListEncoder().encode(counters), forKey: countersKey)
        } catch {
            print(error)
        }
    }
}
