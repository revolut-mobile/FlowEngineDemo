//
// Created by Andrey Chevozerov on 08/06/2018.
// Copyright (c) 2018 Revolut. All rights reserved.
//

import Foundation

extension SurveyFlow {
    enum FlowStep {
        case loadSurvey
        case startSurvey
        case changeScreen(SurveyViewModel.Identifier)
        case showQuestion(SurveyModel, SurveyViewModel)
        case checkAnswers(SurveyModel)
        case showResult(Result<Bool>)
    }

    struct FlowState {
        private (set) var survey: SurveyModel?
        private (set) var isStarted: Bool = false
        private (set) var currentViewId: SurveyViewModel.Identifier?
        private (set) var result: Result<Bool>?
        private (set) var isCompleted: Bool = false
    }
}

extension SurveyFlow.FlowState: FlowStateProtocol {
    enum MutatingAction {
        case setStarted
        case changeViewId(SurveyViewModel.Identifier)
        case setSurvey(SurveyModel)
        case setResult(Result<Bool>)
        case setCompleted
    }

    mutating func mutate(with action: MutatingAction) {
        switch action {
        case .setStarted:
            self.isStarted = true

        case let .changeViewId(viewId):
            self.currentViewId = viewId

        case let .setSurvey(survey):
            self.survey = survey

        case let .setResult(result):
            self.result = result

        case .setCompleted:
            self.isCompleted = true
        }
    }
}
