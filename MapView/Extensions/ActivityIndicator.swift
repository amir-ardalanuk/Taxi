//
//  ActivityIndicator.swift
//  AANetworkProvider
//
//  Created by Amir Ardalan on 4/26/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class ActivityIndicator: SharedSequenceConvertibleType {
   
  public typealias Element = Bool
  public typealias SharingStrategy = DriverSharingStrategy
  
  private let _lock = NSRecursiveLock()
    private let _variable = BehaviorSubject(value: false)
  private let _loading: SharedSequence<SharingStrategy, Bool>
  
  public init() {
        _loading = _variable.asDriver(onErrorJustReturn: false)
      .distinctUntilChanged()
  }
  
  fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
    return source.asObservable()
      .do(onNext: { _ in
        self.sendStopLoading()
      }, onError: { _ in
        self.sendStopLoading()
      }, onCompleted: {
        self.sendStopLoading()
      }, onSubscribe: subscribed)
  }
  
  private func subscribed() {
    _lock.lock()
    _variable.onNext(true)

    _lock.unlock()
  }
  
  private func sendStopLoading() {
    _lock.lock()
    _variable.onNext(false)

    _lock.unlock()
  }
  
  public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
    return _loading
  }
}

extension ObservableConvertibleType {
  public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
    return activityIndicator.trackActivityOfObservable(self)
  }
}
