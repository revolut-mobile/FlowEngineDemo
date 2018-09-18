//
//  MoneyItem.swift
//  FlowEngineDemo
//
//  Created by Andrey Chevozerov on 17/09/2018.
//  Copyright © 2018 revolut. All rights reserved.
//

import Foundation

struct MoneyItem: Codable {
    let amount: Int64
    let currency: String
}

extension MoneyItem {
    static let invalid = MoneyItem(amount: 0, currency: "")
}

extension MoneyItem: Equatable {
    static func == (lhs: MoneyItem, rhs: MoneyItem) -> Bool {
        return lhs.amount == rhs.amount && lhs.currency == rhs.currency
    }
}
