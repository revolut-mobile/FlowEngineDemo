//
// Created by Ilya Velilyaev on 17/05/2018.
// Copyright (c) 2018 Revolut. All rights reserved.
//

import Foundation

protocol FlowStateProtocol {
    associatedtype MutatingAction

    mutating func mutate(with action: MutatingAction)
}

protocol FlowStepPerformerProtocol: class {
    associatedtype FlowStep
    associatedtype FlowState: FlowStateProtocol

    func perform(step: FlowStep, completion: @escaping (FlowState.MutatingAction) -> Void)
}

protocol FlowProtocol: class {
    associatedtype FlowState
    associatedtype FlowStep

    func nextStep(state: FlowState) -> FlowStep?
}

final class FlowEngine<StepPerformer, Flow> where StepPerformer: FlowStepPerformerProtocol,
                                                  Flow: FlowProtocol,
                                                  StepPerformer.FlowStep == Flow.FlowStep,
                                                  StepPerformer.FlowState == Flow.FlowState {

    private let stepPerformer: StepPerformer
    private let flow: Flow

    private let initialState: Flow.FlowState

    init(stepPerformer: StepPerformer, flow: Flow, initialState: Flow.FlowState) {
        self.stepPerformer = stepPerformer
        self.flow = flow
        self.initialState = initialState
    }

    func beginFlow() {
        guard let step = flow.nextStep(state: initialState) else { return }
        continueFlow(step: step, state: initialState)
    }

    private func continueFlow(step: Flow.FlowStep, state: Flow.FlowState) {
        stepPerformer.perform(step: step) { mutatingAction in
            var newState = state
            newState.mutate(with: mutatingAction)
            guard let nextStep = self.flow.nextStep(state: newState) else { return }
            self.continueFlow(step: nextStep, state: newState)
        }
    }
}
