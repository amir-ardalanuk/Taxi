//
//  ErrorTracker.swift
//  AANetworkProvider
//
//  Created by Amir Ardalan on 4/26/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class ErrorTracker: SharedSequenceConvertibleType {
    
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let _subject = PublishSubject<Error>()
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }
    
    public func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }
    
    private func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
}
extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker)->Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
