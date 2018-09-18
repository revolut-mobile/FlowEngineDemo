//
// Created by Andrey Chevozerov on 08/06/2018.
// Copyright (c) 2018 Revolut. All rights reserved.
//

import Foundation

final class SurveyFlow: FlowProtocol {
    func nextStep(state: FlowState) -> FlowStep? {
        guard !state.isCompleted else { return nil }

        if let result = state.result {
            return .showResult(result)
        }

        guard let survey = state.survey else { return .loadSurvey }

        guard state.isStarted else { return .startSurvey }

        guard
            let viewId = state.currentViewId,
            let view = survey.views.first(where: { $0.id == viewId })
        else { return .changeScreen(survey.views[0].id) }

        if view.isFilled {
            if let nextId = view.nextViewId {
                return .changeScreen(nextId)
            } else {
                return .checkAnswers(survey)
            }
        } else {
            return .showQuestion(survey, view)
        }
    }
}
