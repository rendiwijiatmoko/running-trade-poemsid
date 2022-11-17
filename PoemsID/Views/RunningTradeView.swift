//
//  RunningTradeView.swift
//  PoemsID
//
//  Created by Rendi Wijiatmoko on 17/11/22.
//

import SwiftUI

struct RunningTradeView: View {
    @StateObject var viewModel = RunningTradeViewModel()
    @State private var filter = false
    @State private var stockFilter = false
    @State private var searchByCode = ""
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(viewModel.arrayRunningTradeModel) { tradeModel in
                        HStack {
                            HStack {
                                Text(tradeModel.stock)
                                Spacer()
                            }.frame(maxWidth:.infinity)
                            HStack {
                                Spacer()
                                Text(String(tradeModel.price))
                            }.frame(maxWidth:.infinity)
                            HStack {
                                Spacer()
                                Text("\(tradeModel.chg)%")
                            }.frame(maxWidth:.infinity)
                            HStack {
                                Spacer()
                                Text(String(tradeModel.volume))
                                    .foregroundColor(.white)
                            }.frame(maxWidth:.infinity)
                            HStack {
                                Text(tradeModel.act)
                            }.frame(maxWidth:.infinity)
                            HStack {
                                Spacer()
                                Text(tradeModel.time.convertToStringPreviewSimpleWithTime())
                                    .foregroundColor(.white)
                            }.frame(maxWidth:.infinity)
                        }
                        .foregroundColor(tradeModel.colorChg == enumColorChg.netral ? .orange : (tradeModel.colorChg == enumColorChg.profit ? .green : .red))
                    }
                } header: {
                    HStack {
                        HStack {
                            Text("STOCK")
                            Spacer()
                        }.frame(maxWidth:.infinity)
                        HStack {
                            Spacer()
                            Text("PRICE")
                        }.frame(maxWidth:.infinity)
                        HStack {
                            Spacer()
                            Text("CHG")
                        }.frame(maxWidth:.infinity)
                        HStack {
                            Spacer()
                            Text("VOL")
                        }.frame(maxWidth:.infinity)
                        HStack {
                            
                            Text("ACT")
                        }.frame(maxWidth:.infinity)
                        HStack {
                            Spacer()
                            Text("TIME")
                        }.frame(maxWidth:.infinity)
                    }
                    .font(.system(size: 13))
                    .padding(.vertical)
                }
            }
            .font(.system(size: 12))
            .listStyle(.plain)
            
            HStack(alignment:.center) {
                HStack {
                    Spacer()
                    Image(systemName: "line.3.horizontal.decrease")
                    Text("Stock Filter")
                    Text("(\(viewModel.selectedStockFilter.count))")
                        .foregroundColor(.secondary)
                        .opacity(viewModel.selectedStockFilter.isEmpty ? 0 : 1)
                    Spacer()
                }
                .foregroundColor(.orange)
                .onTapGesture {
                    filter.toggle()
                }
                Text("|")
                    .foregroundColor(.gray)
                HStack {
                    Spacer()
                    Text("Filter")
                    Toggle("Filter", isOn: $viewModel.toogleFilter)
                        .labelsHidden()
                        .tint(.orange)
                        .onChange(of: viewModel.toogleFilter) { bool in
                            viewModel.toogleFilterIsSelected(on: bool)
                        }
                    Spacer()
                }
                .foregroundColor(.white)
            }
            .padding(.top)
            .background(Color("Black"))
                
        }
        .frame(maxWidth:.infinity)
        .overlay(
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Text("STOCK FILTER")
                        Spacer()
                        Button {
                            filter = false
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.orange)
                        }
                    }
                    Button {
                        viewModel.selectedStockFilter = []
                        viewModel.toogleFilter = false
                    } label: {
                        Text("CLEAR FILTER")
                            .foregroundColor(viewModel.selectedStockFilter.count == 0 ? .gray : .orange)
                    }.padding(.vertical)
                        .disabled(viewModel.selectedStockFilter.count == 0 )
                    
                    Text("You can add a maximum of 3 stocks")
                    
                    HStack {
                        ForEach(viewModel.selectedStockFilter) {
                            stockModel in
                            Button  {
                                viewModel.removeSelectedFilter(by: stockModel)
                            } label: {
                                HStack {
                                    Text("\(stockModel.stock) x")
                                }
                                .padding(5)
                                .foregroundColor(.primary)
                                .background(.gray)
                                .cornerRadius(5)
                            }
                        }
                        

                        Button {
                            stockFilter.toggle()
                        } label: {
                            Text("Add Stock +")
                                .padding(5)
                                .foregroundColor(.orange)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(.orange, lineWidth: 1)
                                    )
                        }
                        .opacity(viewModel.selectedStockFilter.count == 3 ? 0 : 1)
                    }
                    
                    Spacer()
                    Button {
                        viewModel.filterArray()
                        filter.toggle()
                    } label: {
                        Text("APPLY")
                            .foregroundColor(.primary)
                            .padding()
                            .cornerRadius(5)
                    }
                    .frame(maxWidth:.infinity)
                    .background(.orange)
                    .disabled(viewModel.selectedStockFilter.isEmpty)

                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 450)
                .background(Color("Black"))
                .sheet(isPresented: $stockFilter) {
                    VStack {
                        HStack {
                            Button {
                                stockFilter.toggle()
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.orange)
                            }
                            Spacer()
                            Text("STOCKS")
                            Spacer()
                        }.padding()
                        SearchBarView(text: $viewModel.searchTerm)
                        List {
                            Section {
                                ForEach(viewModel.arrayStocksModel) {
                                    runningTradeModel in
                                    HStack {
                                        VStack(alignment:.leading) {
                                            Text(runningTradeModel.stock)
                                                .foregroundColor(.orange)
                                            Text(runningTradeModel.name)
                                                .font(.system(size: 10))
                                        }
                                        
                                        Spacer()
                                        HStack {
                                            Text("S")
                                                .foregroundColor(runningTradeModel.stockType.contains(enumStockType.S) ? .white : .gray)
                                            Text("M")
                                                .foregroundColor(runningTradeModel.stockType.contains(enumStockType.M) ? .white : .gray)
                                            Text("L")
                                                .foregroundColor(runningTradeModel.stockType.contains(enumStockType.L) ? .white : .gray)
                                        }
                                    }
                                    .padding(.vertical, 5)
                                    .onTapGesture {
                                        viewModel.selectedFilter(by: runningTradeModel)
                                        stockFilter.toggle()
                                    }
                                    
                                }
                            } header: {
                                HStack
                                {
                                    Text("Recently Viewed")
                                    Spacer()
                                    Text("Stock Type")
                                }
                            }
                            
                        }
                        .listStyle(.plain)
                        Spacer()
                    }
//                    .padding()
                    .preferredColorScheme(.dark)
                }
            }
            .opacity(filter ? 1 : 0)
        )
        .alert(isPresented: $viewModel.alert)
        {
            return Alert(
                title: Text(""),
                message: Text("You need to add at least 1 stock to turn on the filter"),
                primaryButton: .default(Text("ADD STOCK")) {
                    filter.toggle()
                },
                secondaryButton: .cancel()
            
            )
        }
        .navigationTitle("Running Trade")
    }
}

struct RunningTradeView_Previews: PreviewProvider {
    static var previews: some View {
        RunningTradeView()
            .preferredColorScheme(.dark)
    }
}
