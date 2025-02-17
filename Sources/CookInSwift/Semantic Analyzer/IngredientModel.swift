//
//  IngredientModel.swift
//
//
//  Created by Alexey Dubovskoy on 17/04/2021.
//

import Foundation


public class IngredientAmount {
//    TODO remove refs to internal ValuesNode
    public var quantity: ValuesNode
    public var units: String

    init(_ quantity: ValuesNode, _ units: String) {
        self.quantity = quantity
        self.units = units
    }

    init(_ quantity: ConstantNode, _ units: String) {
        self.quantity = ValuesNode(quantity)
        self.units = units
    }

    init(_ quantity: Int, _ units: String) {
        self.quantity = ValuesNode(quantity)
        self.units = units
    }
}


public class IngredientAmountCollection {
    var amountsCountable: [String: Decimal] = [:]
    var amountsUncountable: [String: String] = [:]

    func add(_ amount: IngredientAmount) {
        let units = amount.units.singularize

        // TODO
        switch amount.quantity.values.first {
        case let .integer(value):
            amountsCountable[units] = amountsCountable[units, default: 0] + Decimal(value)
        case let .decimal(value):
            amountsCountable[units] = amountsCountable[units, default: 0] + value
        case let .fractional(value):
            amountsCountable[units] = amountsCountable[units, default: 0] + Decimal(value.0)/Decimal(value.1)
        case let .string(value):
            amountsUncountable[amount.units] = value
        case .none:
            fatalError("Shite!")
        }
    }
}

public class IngredientTable {
    public var ingredients: [String: IngredientAmountCollection] = [:]

    public init() {
    }

    public func add(name: String, amount: IngredientAmount) {
        if ingredients[name] == nil {
            ingredients[name] = IngredientAmountCollection()
        }

        ingredients[name]?.add(amount)
    }

    public func add(name: String, amounts: IngredientAmountCollection) {
        amounts.forEach {
            add(name: name, amount: $0)
        }
    }
}
