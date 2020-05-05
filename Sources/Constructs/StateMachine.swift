//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

public class StateMachine<Delegate: StateMachineDelegate> {
    
    public private(set) var state: Delegate.State
    
    public weak var delegate: Delegate?
    
    private var fireOnMainQueue: Bool
    
    public init(initialState: Delegate.State, fireOnMainQueue: Bool = false) {
        state = initialState
        self.fireOnMainQueue = fireOnMainQueue
    }
    
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

public protocol StateMachineDelegate: AnyObject {
    
    associatedtype State
    associatedtype Event
    
    /// Return state to transition to from the current state given an event.
    /// Return nil to not trigger a transition.
    /// Return the from state for a loopback transition to itself.
    func stateToTransitionTo(from state: State, dueTo event: Event) -> State?
    
    func willTransition(from state: State, to newState: State, dueTo event: Event)
    
    func didTransition(from state: State, to newState: State, dueTo event: Event)
}
