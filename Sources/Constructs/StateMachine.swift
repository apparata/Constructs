//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

/// A generic state machine that transitions between states in response to events.
///
/// Uses a delegate to determine valid state transitions and perform transition-related actions.
/// Optionally ensures that state transitions occur on the main queue.
///
public class StateMachine<Delegate: StateMachineDelegate> {

    /// The current state of the state machine.
    public private(set) var state: Delegate.State

    /// The delegate responsible for determining state transitions and receiving transition callbacks.
    public weak var delegate: Delegate?

    private var fireOnMainQueue: Bool

    /// Initializes the state machine with an initial state and queue behavior.
    ///
    /// - Parameters:
    ///   - initialState: The initial state of the state machine.
    ///   - fireOnMainQueue: Whether to always perform state transitions on the main queue.
    ///
    public init(initialState: Delegate.State, fireOnMainQueue: Bool = false) {
        state = initialState
        self.fireOnMainQueue = fireOnMainQueue
    }

    /// Fires an event and attempts to transition to a new state based on the delegate's logic.
    ///
    /// - Parameter event: The event that may trigger a state transition.
    ///
    public func fireEvent(_ event: Delegate.Event) {
        if fireOnMainQueue, !Thread.current.isMainThread {
            DispatchQueue.main.sync {
                self.internalFireEvent(event)
            }
        } else {
            internalFireEvent(event)
        }
    }

    private func internalFireEvent(_ event: Delegate.Event) {
        if let newState = delegate?.stateToTransitionTo(from: state, dueTo: event) {
            delegate?.willTransition(from: state, to: newState, dueTo: event)
            let oldState = state
            state = newState
            delegate?.didTransition(from: oldState, to: state, dueTo: event)
        }
    }
}

/// A protocol defining the contract for providing state transitions and callbacks to a `StateMachine`.
public protocol StateMachineDelegate: AnyObject {

    associatedtype State
    associatedtype Event

    /// Determines the next state based on the current state and an event.
    ///
    /// - Parameters:
    ///   - state: The current state.
    ///   - event: The event to evaluate.
    /// - Returns: The new state to transition to, or `nil` to prevent a transition,
    ///            or the from state for a loopback transition.
    ///
    func stateToTransitionTo(from state: State, dueTo event: Event) -> State?

    /// Called just before the state machine transitions to a new state.
    ///
    /// - Parameters:
    ///   - state: The current state.
    ///   - newState: The state to transition to.
    ///   - event: The event that triggered the transition.
    ///
    func willTransition(from state: State, to newState: State, dueTo event: Event)

    /// Called after the state machine has transitioned to a new state.
    ///
    /// - Parameters:
    ///   - state: The previous state.
    ///   - newState: The new current state.
    ///   - event: The event that triggered the transition.
    ///
    func didTransition(from state: State, to newState: State, dueTo event: Event)
}
