//
// Created by Andrey Chevozerov on 08/06/2018.
// Copyright (c) 2018 Revolut. All rights reserved.
//

import Foundation

final class SurveyFlowPerformer: FlowStepPerformerProtocol {
    typealias FlowState = SurveyFlow.FlowState
    typealias FlowStep = SurveyFlow.FlowStep

    private let interactor = SurveyInteractor()

    func perform(step: FlowStep, completion: @escaping (FlowState.MutatingAction) -> Void) {
        switch step {
        case .loadSurvey:
            print("load survey")
            interactor.getCurrentSurvey { surveyModel in
                completion(.setSurvey(surveyModel))
            }

        case .startSurvey:
            print("start survey")
            showIntroScreen {
                completion(.setStarted)
            }

        case let .changeScreen(identifier):
            print("change screen to \(identifier.rawValue)")
            completion(.changeViewId(identifier))

        case .showQuestion(let survey, let view):
            print("show current screen")
            showQuestionScreen(survey: survey, view: view) { updated in
                completion(.setSurvey(updated))
            }

        case let .checkAnswers(survey):
            print("submit survey")
            interactor.submitSurvey(survey) { result in
                completion(.setResult(result))
            }

        case let .showResult(result):
            print("show results")
            showResultScreen(result) {
                completion(.setCompleted)
            }
        }
    }
}

private extension SurveyFlowPerformer {
    func showIntroScreen(_ completion: @escaping () -> Void) {
        // todo: show intro screen
        completion()
    }

    func showQuestionScreen(survey: SurveyModel, view: SurveyViewModel, completion: @escaping (SurveyModel) -> Void) {
        // todo: show question screen
        var updatedView = view
        if let item = updatedView.items.randomElement() {
            let updatedItem: SurveyViewModel.Item
            switch item.type {
            case let .checkbox(text, _):
                updatedItem = SurveyViewModel.Item(id: item.id, type: .checkbox(text: text, value: true))
            case let .radio(text, group, _):
                updatedItem = SurveyViewModel.Item(id: item.id, type: .radio(text: text, group: group, value: true))
            case let .moneyInput(currencies, _):
                updatedItem = SurveyViewModel.Item(id: item.id, type: .moneyInput(currencies: currencies, value: MoneyItem(amount: 10000, currency: currencies[0])))
            }
            if let index = updatedView.items.index(of: item) {
                updatedView.items[index] = updatedItem
            }
        }
        var updatedSurvey = survey
        if let index = updatedSurvey.views.index(where: { $0.id == view.id }) {
            updatedSurvey.views[index] = updatedView
        }
        completion(updatedSurvey)
    }

    func showResultScreen(_ result: Result<Bool>, completion: @escaping () -> Void) {
        // todo: show survey result screen
        completion()
    }
}
