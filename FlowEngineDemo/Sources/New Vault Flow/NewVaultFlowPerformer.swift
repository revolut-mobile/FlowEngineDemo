//
//  NewVaultFlowPerformer.swift
//  FlowEngineDemo
//
//  Created by Andrey Chevozerov on 18/09/2018.
//  Copyright © 2018 revolut. All rights reserved.
//

import Foundation

final class NewVaultFlowPerformer: FlowStepPerformerProtocol {
    typealias FlowState = NewVaultFlow.FlowState
    typealias FlowStep = NewVaultFlow.FlowStep

    private let interactor = NewVaultInteractor()

    func perform(step: FlowStep, completion: @escaping (FlowState.MutatingAction) -> Void) {
        switch step {
        case .prepareFlow:
            print("prepare flow")
            let isAvailable = interactor.checkSpareChangeAvailability()
            completion(.setOptions(spareChangeAllowed: isAvailable))

        case .inputVaultName:
            print("show name input screen")
            showVaultNameScreen { name in
                completion(.setVaultName(name))
            }

        case .chooseVaultGoal:
            print("show goal input screen")
            showVaultGoalScreen { amount in
                completion(.setVaultGoal(amount))
            }

        case .toggleSpareChange:
            print("show spare change screen")
            showSpareChangeScreen { isEnabled in
                completion(.setSpareChange(isEnabled))
            }

        case let .createVault(name, goal, spareChange):
            print("create new vault")
            interactor.createNewVault(name: name, goal: goal, enableSpareChange: spareChange) { result in
                completion(.setResult(result))
            }

        case let .showResult(result):
            print("show result screen")
            showResultScreen(result) {
                completion(.setComplete)
            }
        }
    }
}

private extension NewVaultFlowPerformer {
    func showVaultNameScreen(_ completion: @escaping (String) -> Void) {
        // todo: open screen
        completion("iPhone Xs Max")
    }

    func showVaultGoalScreen(_ completion: @escaping (MoneyItem) -> Void) {
        // todo: open screen
        completion(MoneyItem(amount: 999_00, currency: "GBP"))
    }

    func showSpareChangeScreen(_ completion: @escaping (Bool) -> Void) {
        // todo: open screen
        completion(true)
    }

    func showResultScreen(_ result: Result<Vault>, completion: @escaping () -> Void) {
        // todo: open screen
        completion()
    }
}
