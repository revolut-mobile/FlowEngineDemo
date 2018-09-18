//
//  SurveyInteractor.swift
//  FlowEngineDemo
//
//  Created by Andrey Chevozerov on 18/09/2018.
//  Copyright © 2018 revolut. All rights reserved.
//

import Foundation

final class SurveyInteractor {
    func getCurrentSurvey(_ completion: @escaping (SurveyModel) -> Void) {
        guard let path = Bundle.main.path(forResource: "SurveyExample", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)
            let model = try JSONDecoder().decode(SurveyModel.self, from: data)
            completion(model)
        } catch {
            print("\(error)")
        }
    }

    func submitSurvey(_ surveyModel: SurveyModel, completion: @escaping (Result<Bool>) -> Void) {
        // todo: send survey and process response
        completion(.success(true))
    }
}
