//
//  RemoteLocationEntity.swift
//  MapView
//
//  Created by Amir  on 10/23/20.
//  Copyright © 2020 Amir . All rights reserved.
//

import Foundation

struct RemoteLocationEntity : Codable {

    let poiList : [PoiList]?
//
//
//    enum CodingKeys: String, CodingKey {
//        case poiList = "poiList"
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        poiList = try values.decodeIfPresent([PoiList].self, forKey: .poiList)
//    }


}
struct PoiList : Codable {
    enum PoiState: String, Codable {
        case active = "ACTIVE"
        case inactive = "INACTIVE"
    }
    let coordinate : Coordinate?
    let heading : Float?
    let id : Int?
    let state : PoiState?
    let type : String?

//
//    enum CodingKeys: String, CodingKey {
//        case coordinate
//        case heading = "heading"
//        case id = "id"
//        case state = "state"
//        case type = "type"
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        coordinate = try Coordinate(from: decoder)
//        heading = try values.decodeIfPresent(Float.self, forKey: .heading)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        state = try values.decodeIfPresent(String.self, forKey: .state)
//        type = try values.decodeIfPresent(String.self, forKey: .type)
//    }


}
struct Coordinate : Codable {

    let latitude : Double?
    let longitude : Double?
    
    var isEmpty: Bool {
        return latitude == nil || longitude == nil
    }


//    enum CodingKeys: String, CodingKey {
//        case latitude = "latitude"
//        case longitude = "longitude"
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        latitude = try values.decodeIfPresent(Float.self, forKey: .latitude)
//        longitude = try values.decodeIfPresent(Float.self, forKey: .longitude)
//    }
}
