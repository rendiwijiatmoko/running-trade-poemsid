//
//  RunningTradeViewModel.swift
//  PoemsID
//
//  Created by Rendi Wijiatmoko on 17/11/22.
//

import Foundation
import Combine

class RunningTradeViewModel: ObservableObject {
    @Published var arrayRunningTradeModel: [RunningTradeModel] = [RunningTradeModel]()
    @Published var arrayStocksModel: [RunningTradeModel] = [RunningTradeModel]()
    @Published var selectedStockFilter: [RunningTradeModel] = [RunningTradeModel]()
    @Published var searchTerm: String = ""
    @Published var toogleFilter: Bool = false
    @Published var alert: Bool = false
    
    var subscriptions = Set<AnyCancellable>()
        
    init() {
            $searchTerm
                .removeDuplicates()
                .dropFirst()
                .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
                .sink { [weak self] term in
                    self?.arrayStocksModel = demoData
                self?.searchStock(for: term)
            }.store(in: &subscriptions)
            self.arrayStocksModel = demoDataUniq
            self.arrayRunningTradeModel = demoData
        }
    
    func filterArray() {
        var filteredArray: [RunningTradeModel] = [RunningTradeModel]()
        if selectedStockFilter.count == 2 {
            filteredArray = demoData.filter({ $0.stock.contains(selectedStockFilter[0].stock) || $0.stock.contains(selectedStockFilter[1].stock)})
        } else if selectedStockFilter.count == 3 {
            filteredArray = demoData.filter({ $0.stock.contains(selectedStockFilter[0].stock) || $0.stock.contains(selectedStockFilter[1].stock) || $0.stock.contains(selectedStockFilter[2].stock) })
        } else if selectedStockFilter.count == 1 {
            filteredArray = demoData.filter({ $0.stock.contains(selectedStockFilter[0].stock) })
        } else {
            filteredArray = []
        }
        self.arrayRunningTradeModel = filteredArray
        self.toogleFilter = true
    }
    
    func toogleFilterIsSelected(on value: Bool) {
        if !value {
            self.toogleFilter = false
            self.arrayRunningTradeModel = demoData
        } else {
            if selectedStockFilter.count == 0 {
                toogleFilter = false
                alert = true
            }
            else {
                self.filterArray()
            }
            
        }
        
    }
    
    func searchStock(for searchTerm: String) {
        guard !searchTerm.isEmpty else {
            return
        }
        
        let result = demoData.filter { $0.stock.lowercased().contains(searchTerm.lowercased())}
        self.arrayStocksModel = result
    }
    
    func selectedFilter(by stock: RunningTradeModel) {
        if !selectedStockFilter.contains(stock) {
            selectedStockFilter.append(stock)
        }
    }
    
    func removeSelectedFilter(by stock: RunningTradeModel) {
        selectedStockFilter.removeAll { value in
            return value == stock
        }
    }
}

extension Date {
    func convertToStringPreviewSimpleWithTime() -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: self)
    }
}
