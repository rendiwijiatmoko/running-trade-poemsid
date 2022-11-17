//
//  RunningTradeModel.swift
//  PoemsID
//
//  Created by Rendi Wijiatmoko on 17/11/22.
//

import Foundation

struct RunningTradeModel: Identifiable, Decodable, Hashable {
    var id = UUID().uuidString
    
    var stock: String
    var name: String
    var price: Int
    var chg: String
    var volume: Int
    var act: String
    var time: Date
    var colorChg: enumColorChg = .netral
    var stockType: [enumStockType]
}

enum enumColorChg: Codable {
    case profit
    case loss
    case netral
}

enum enumStockType: Codable {
    case S
    case M
    case L
}
