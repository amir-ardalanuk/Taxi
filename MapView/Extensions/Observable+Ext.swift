//
//  File.swift
//  AANetworkProvider
//
//  Created by Amir Ardalan on 4/26/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where Element == Bool {
  /// Boolean not operator
  public func not() -> Observable<Bool> {
    return self.map(!)
  }
  
}

extension SharedSequenceConvertibleType {
  func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
    return map { _ in }
  }
}

extension ObservableType {
  
  func catchErrorJustComplete() -> Observable<Element> {
    return catchError { _ in
      return Observable.empty()
    }
  }
  
  func asDriverOnErrorJustComplete() -> Driver<Element> {
    return asDriver { _ in
      return Driver.empty()
    }
  }
  
  func mapToVoid() -> Observable<Void> {
    return map { _ in }
  }
}
