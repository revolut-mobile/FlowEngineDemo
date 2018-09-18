//
// Created by Andrey Chevozerov on 08/06/2018.
// Copyright (c) 2018 Revolut. All rights reserved.
//

import Foundation

struct SurveyRouteModel: Codable {

    struct Condition: Codable {
        enum Value {
            case boolean(Bool)
            case moneyEqual(MoneyItem)
            case moneyLess(MoneyItem)
            case moneyMore(MoneyItem)
        }

        let itemId: SurveyViewModel.Item.Identifier
        let value: Value
    }

    let viewId: SurveyViewModel.Identifier
    let conditions: [Condition]
}

// MARK: - Mapping stuff

extension SurveyRouteModel {
    private enum CodingKeys: String, CodingKey {
        case viewId = "id", conditions
    }
}

extension SurveyRouteModel.Condition {
    private enum CodingKeys: String, CodingKey {
        case itemId, type, value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        itemId = try container.decode(SurveyViewModel.Item.Identifier.self, forKey: .itemId)
        let key = try container.decode(String.self, forKey: .type)
        switch key {
        case "BOOLEAN":
            value = .boolean(try container.decode(Bool.self, forKey: .value))

        default:
            throw DecodingError.valueNotFound(String.self, .init(codingPath: [ CodingKeys.type ], debugDescription: "Unknown type '\(key)'"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(itemId, forKey: .itemId)
        switch value {
        case let .boolean(value):
            try container.encode("BOOLEAN", forKey: .type)
            try container.encode(value, forKey: .value)
        case .moneyEqual:
            // todo: implement it when the API has support
            break
        case .moneyLess:
            // todo: implement it when the API has support
            break
        case .moneyMore:
            // todo: implement it when the API has support
            break
        }
    }
}
