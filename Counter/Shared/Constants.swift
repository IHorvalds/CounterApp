//
//  Constants.swift
//  Counter
//
//  Created by Tudor Croitoru on 29/05/2019.
//  Copyright © 2019 Tudor Croitoru. All rights reserved.
//

import Foundation

let defaults    = UserDefaults(suiteName: "CounterDefaults")
let countersKey = "countersKey"
let themeKey    = "theme"

var globalCounters = Counter.getAllCountersFromDefaults()
