//
//  Mapper.swift
//  MapView
//
//  Created by Amir  on 10/23/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation

protocol Mapper {
    func map<T: Decodable>(data: Data) -> T?
}

struct JsonMapper: Mapper {
    func map<T>(data: Data) -> T? where T: Decodable {
        let cllss = T.self
        // *** to decode json data for debugginh
        //let json = try? JSONSerialization.jsonObject(with: callback?.data as? Data ?? Data(), options: []) as? [String : Any]
        // *** END
        let model = try? JSONDecoder().decode(cllss, from: data)
        return model
    }
}
