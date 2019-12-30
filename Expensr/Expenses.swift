//
//  Expenses.swift
//  Expensr
//
//  Created by Dabrowski,Brendyn on 12/28/19.
//  Copyright © 2019 BDCreative. All rights reserved.
//

import Foundation

class Expenses {

    static let shared = Expenses()

    private let defaults = UserDefaults.standard

    private static let allowance: Double = 500

    var expensesArray = [Expense]()

    var totalExpenses: Double = 0 {
       didSet {
           UserDefaults.standard.set(self.totalExpenses, forKey: Self.totalExpensesKey)
       }
    }

    var cashBalance: Double = 0 {
       didSet {
           UserDefaults.standard.set(self.cashBalance, forKey: Self.cashBalanceKey)
       }
    }

    var foodExpenses: Double = 0 {
        didSet {
            UserDefaults.standard.set(self.foodExpenses, forKey: Self.foodExpensesKey)
        }
    }

    var groceriesExpenses: Double = 0 {
        didSet {
            UserDefaults.standard.set(self.groceriesExpenses, forKey: Self.groceriesExpensesKey)
        }
    }

    var miscExpenses: Double = 0 {
       didSet {
           UserDefaults.standard.set(self.miscExpenses, forKey: Self.miscExpensesKey)
       }
    }

    var gasExpenses: Double = 0 {
       didSet {
           UserDefaults.standard.set(self.gasExpenses, forKey: Self.gasExpensesKey)
       }
    }

    var otbExpenses: Double = 0 {
       didSet {
           UserDefaults.standard.set(self.otbExpenses, forKey: Self.otbExpensesKey)
       }
    }

    private init() {
        self.loadExpenses()
    }

    func add(_ expense: Expense, completion: () -> Void) {
        self.write(expense)
        self.update(expense, completion: completion)
    }

    func write(_ expense: Expense) {
        self.expensesArray.append(expense)
        do {
            let encodedData = try JSONEncoder().encode(self.expensesArray)
            self.defaults.set(encodedData, forKey: Self.expensesArrayKey)
        } catch {
            print("Unable to write to user defaults.")
        }
    }

    func update(_ expense: Expense, completion: () -> Void) {
        switch expense.category {
            case "Food":
                self.foodExpenses += expense.expense
            case "Groceries":
                self.groceriesExpenses += expense.expense
            case "Misc":
                self.miscExpenses += expense.expense
            case "Gas":
                self.gasExpenses += expense.expense
            case "OTB":
                self.otbExpenses += expense.expense
        default:
            break
        }

        self.updateTotals()

        completion()
    }

    func updateTotals() {
        self.totalExpenses = self.foodExpenses + self.groceriesExpenses + self.miscExpenses
        self.cashBalance = Self.allowance - self.totalExpenses
    }

    func resetExpenses(completion: () -> Void) {
        self.totalExpenses = 0
        self.foodExpenses = 0
        self.groceriesExpenses = 0
        self.miscExpenses = 0
        self.gasExpenses = 0
        self.otbExpenses = 0
        self.expensesArray = []

        self.updateTotals()

        completion()
    }

    private func loadExpenses() {
        self.totalExpenses = self.defaults.double(forKey: Self.totalExpensesKey)
        self.cashBalance = self.defaults.double(forKey: Self.cashBalanceKey)
        self.foodExpenses = self.defaults.double(forKey: Self.foodExpensesKey)
        self.groceriesExpenses = self.defaults.double(forKey: Self.groceriesExpensesKey)
        self.miscExpenses = self.defaults.double(forKey: Self.miscExpensesKey)
        self.gasExpenses = self.defaults.double(forKey: Self.gasExpensesKey)
        self.otbExpenses = self.defaults.double(forKey: Self.otbExpensesKey)
        self.expensesArray = self.decodeArray() ?? []
    }

    private func decodeArray() -> [Expense]? {
        if let data = self.defaults.object(forKey: Self.expensesArrayKey) as? Data {
            do {
                return try JSONDecoder().decode([Expense].self, from: data)
            } catch {
                print("Error while decoding user data")
            }
        }
        return nil
    }
}
