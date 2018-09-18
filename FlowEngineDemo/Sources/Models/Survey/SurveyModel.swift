//
// Created by Andrey Chevozerov on 08/06/2018.
// Copyright (c) 2018 Revolut. All rights reserved.
//

import Foundation

struct SurveyModel: Codable {
    typealias Identifier = GenericIdentifier <SurveyModel, String>

    enum State: String, Codable {
        case complete = "COMPLETE"
        case incomplete = "INCOMPLETE"
    }

    let id: Identifier
    let version: String
    let state: State
    let name: String
    var views: [SurveyViewModel]
}
