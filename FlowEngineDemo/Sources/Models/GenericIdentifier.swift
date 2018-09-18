//
//  GenericIdentifier.swift
//  Revolut
//
//  Created by Andrey Chevozerov on 18/07/2017.
//  Copyright © 2017 Revolut. All rights reserved.
//

import Foundation

// Implementation of strong-typed identifiers for server-side objects
// See: http://tom.lokhorst.eu/2017/07/strongly-typed-identifiers-in-swift

struct GenericIdentifier<Object, IdType: Hashable & Codable>: RawRepresentable, Hashable, Equatable {
    let rawValue: IdType

    init(rawValue: IdType) {
        self.rawValue = rawValue
    }
}

extension GenericIdentifier: CustomStringConvertible {
    var description: String {
        return "\(rawValue)"
    }
}

extension RawRepresentable where RawValue: Hashable {
    public var hashValue: Int {
        return rawValue.hashValue
    }
}

extension GenericIdentifier: Codable {
    init(from decoder: Decoder) throws {
        rawValue = try decoder.singleValueContainer().decode(IdType.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
