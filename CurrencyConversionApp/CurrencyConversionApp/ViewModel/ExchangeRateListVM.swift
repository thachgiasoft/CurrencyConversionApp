//
//  ExchangeRateListVM.swift
//  CurrencyConversionApp
//
//  Created by Toru Nakandakari on 2020/02/15.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

final class ExchangeRateListVM: ObservableObject {
    
    @Published private(set) var exchangeRateListRowVMs = [ExchangeRateListRowVM]()

    private var inputAmount: Double = 0.0
    private var selectedUnit: String = ""

    // 通貨情報から他通貨リストアイテム用のViewModelを生成する
    func createExchangeRateListRowVMs(currencies: [Currency]) {
        self.exchangeRateListRowVMs = currencies.map { (currency) in ExchangeRateListRowVM(currency: currency) }
    }
    
    // 入力通貨量が変わると呼ばれる
    func updateInputAmount(amount: Double) {
        self.inputAmount = amount
        updateAmount()
    }
    
    // 基準通貨が変わった時に呼ばれる
    func updateUnit(unit: String) {
        self.selectedUnit = unit
        updateAmount()
    }
    
    // 他通貨の量を更新する
    private func updateAmount() {
        let amountBasedOnUsd = convertUSDPerOneDoller(from: self.selectedUnit)
        let amount = calcUSDAmount(inputAmount: self.inputAmount, amountBasedOnUSD: amountBasedOnUsd)
        exchangeRateListRowVMs.forEach { (viewModel) in
            viewModel.updateRate(usdAmount: amount)
        }
    }
    
    // 現在入力されている通貨量, 選択されている通貨単位を基準となるUSDあたりの通貨量に変換する
    func calcUSDAmount(inputAmount: Double, amountBasedOnUSD: Double) -> Double {
        return inputAmount / amountBasedOnUSD
    }
    
    // USDの1ドルあたりの通貨量に変換する
    private func convertUSDPerOneDoller(from: String) -> Double {
        guard let listRowVM = exchangeRateListRowVMs.first(where: { (listRowVM) in listRowVM.currency.unit == from }) else {
            return 0.0
        }
        return listRowVM.currency.amountBasedOnUSD
    }
}
