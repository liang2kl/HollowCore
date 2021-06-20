//
//  RequestPublisher.swift
//  Hollow
//
//  Created by liang2kl on 2021/2/22.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Combine

public struct RequestPublisher<R>: Publisher where R: Request {
    
    public typealias Output = R.ResultData
    public typealias Failure = R.Error
    
    let configuration: R.Configuration
    
    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subsription = RequestSubscription(request: R(configuration: configuration), subscriber: subscriber)
        subscriber.receive(subscription: subsription)
    }
}

fileprivate class RequestSubscription<S: Subscriber, R: Request>: Subscription where S.Input == R.ResultData, S.Failure == R.Error {
    private let request: R
    private var subscriber: S?
    
    init(request: R, subscriber: S) {
        self.request = request
        self.subscriber = subscriber
    }
    
    func request(_ demand: Subscribers.Demand) {
        guard let subscriber = subscriber else { return }
        request.performRequest(completion: { result in
            if case .success(let data) = result {
                _ = subscriber.receive(data)
            }
            if case .failure(let error) = result {
                subscriber.receive(completion: .failure(error))
            }
            
            // The publisher only emit value or fail once.
            subscriber.receive(completion: .finished)
        })
    }
    
    func cancel() {
        subscriber = nil
    }
}

