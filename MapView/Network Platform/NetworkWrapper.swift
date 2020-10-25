//
//  NetworkWrapper.swift
//  MapView
//
//  Created by Amir  on 10/23/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum NetworkError: Error {
    case invalidURL(String)
    case invalidJSON(String)
    case invalidParameter(String,Any)
}

protocol NetworkWrapper {
    func request<T:Codable>(endpoint: String, query: [String: Any]) -> Observable<T>
}

extension NetworkWrapper {
    func request<T:Codable>(endpoint: String, query: [String: Any] = [:]) -> Observable<T> {
           do {
               guard let url = URL(string: endpoint),
                   var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                   else {
                       throw NetworkError.invalidURL(endpoint)
               }
             
            components.query = query.compactMap({ (key, value) -> String in
                   return "\(key)=\(value)"
               }).joined(separator: "&")
               
               guard let finalURL = components.url else {
                   throw NetworkError.invalidURL(endpoint)
               }
               
                var request = URLRequest(url: finalURL)
                request.timeoutInterval = 10
               return URLSession.shared.rx.response(request: request)
                   .map { _, data -> T in
                    let mapper = JsonMapper()
                    if let response: T = mapper.map(data: data) {
                        return response
                    }else {
                        throw NetworkError.invalidJSON(finalURL.absoluteString)
                    }
               }
           } catch {
               return Observable.empty()
           }
       }
}
