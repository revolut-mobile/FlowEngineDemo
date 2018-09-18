//
// Created by Andrey Chevozerov on 08/06/2018.
// Copyright (c) 2018 Revolut. All rights reserved.
//

import Foundation

struct SurveyViewModel: Codable {
    typealias Identifier = GenericIdentifier<SurveyViewModel, String>

    enum ViewType: String, Codable {
        case form = "FORM"
    }

    struct Item: Codable {
        typealias Identifier = GenericIdentifier<SurveyViewModel.Item, String>

        enum ItemType {
            case checkbox(text: String, value: Bool)
            case radio(text: String, group: Int, value: Bool)
            case moneyInput(currencies: [String], value: MoneyItem?)
        }

        let id: Identifier
        let type: ItemType
    }

    let id: Identifier
    let type: ViewType
    let next: [SurveyRouteModel]
    let title: String
    let subtitle: String
    var items: [Item]
}

extension SurveyViewModel {
    var isFilled: Bool {
        guard items.count > 0 else { return true }
        switch items[0].type {
        case let .moneyInput(_, amount):
            return amount != nil
        case .checkbox:
            return items.reduce(false) {
                guard case let .checkbox(_, value) = $1.type else { return $0 }
                return $0 || value
            }
        case .radio:
            var groups: [Int: Bool] = [:]
            items.forEach {
                guard case let .radio(_, group, value) = $0.type else { return }
                if let old = groups[group] {
                    groups[group] = old || value
                } else {
                    groups[group] = value
                }
            }
            return groups.reduce(true) { $0 && $1.value }
        }
    }

    var nextViewId: Identifier? {
        return next.first(where: match)?.viewId
    }

    private func match(to route: SurveyRouteModel) -> Bool {
        return route.conditions.reduce(true) { result, condition in
            guard let item = items.first(where: { $0.id == condition.itemId }) else { return false }
            switch item.type {
            case let .radio(_, _, value), let .checkbox(_, value):
                switch condition.value {
                case let .boolean(target):
                    return result && (target == value)
                case .moneyEqual, .moneyLess, .moneyMore:
                    return false
                }
            case let .moneyInput(_, value):
                guard let amount = value else { return false }
                switch condition.value {
                case .boolean:
                    return false
                case let .moneyMore(target):
                    return result && (amount.amount > target.amount)
                case let .moneyLess(target):
                    return result && (amount.amount < target.amount)
                case let .moneyEqual(target):
                    return result && (amount.amount == target.amount)
                }
            }
        }
    }
}

extension SurveyViewModel.Item: Equatable {
    static func == (lhs: SurveyViewModel.Item, rhs: SurveyViewModel.Item) -> Bool {
        guard lhs.id == rhs.id else { return false }
        switch (lhs.type, rhs.type) {
        case let (.checkbox(leftText, leftValue), .checkbox(rightText, rightValue)):
            return leftText == rightText && leftValue == rightValue
        case let (.radio(leftText, leftGroup, leftValue), .radio(rightText, rightGroup, rightValue)):
            return leftText == rightText && leftGroup == rightGroup && leftValue == rightValue
        case let (.moneyInput(leftCurrencies, leftValue), .moneyInput(rightCurrencies, rightValue)):
            return leftCurrencies == rightCurrencies && leftValue == rightValue
        default:
            return false
        }
    }
}

// MARK: - Mapping stuff

extension SurveyViewModel.Item {
    private enum CodingKeys: String, CodingKey {
        case id, type, group, description, currencies, value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Identifier.self, forKey: .id)

        let key = try container.decode(String.self, forKey: .type)
        switch key {
        case "SINGLE_CHOICE":
            let group = try container.decode(Int.self, forKey: .group)
            let text = try container.decode(String.self, forKey: .description)
            type = .radio(text: text, group: group, value: false)

        case "MULTI_CHOICE":
            let text = try container.decode(String.self, forKey: .description)
            type = .checkbox(text: text, value: false)

        case "MONEY_INPUT":
            let currencies = try container.decode(Array<String>.self, forKey: .currencies)
            type = .moneyInput(currencies: currencies, value: nil)

        default:
            throw DecodingError.valueNotFound(String.self, .init(codingPath: [ CodingKeys.type ], debugDescription: "Unknown type '\(key)'"))
        }
    }

    private struct Value<T: Encodable>: Encodable {
        let value: T
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        switch type {
        case let .radio(text, group, value):
            try container.encode("SINGLE_CHOICE", forKey: .type)
            try container.encode(group, forKey: .group)
            try container.encode(text, forKey: .description)
            if value {
                try container.encode(Value(value: value), forKey: .value)
            }

        case let .checkbox(text, value):
            try container.encode("MULTI_CHOICE", forKey: .type)
            try container.encode(text, forKey: .description)
            if value {
                try container.encode(Value(value: value), forKey: .value)
            }

        case let .moneyInput(currencies, value):
            try container.encode("MONEY_INPUT", forKey: .type)
            try container.encode(currencies, forKey: .currencies)
            if let amount = value {
                try container.encode(amount, forKey: .value)
            }
        }
    }
}
