//
//  Expenses.swift
//  Expensr
//
//  Created by Dabrowski,Brendyn on 12/28/19.
//  Copyright © 2019 BDCreative. All rights reserved.
//

import Foundation

struct Expense: Codable {

    private let defaults = UserDefaults.standard

    var expense: Double

    var category: String

    var note: String

    var dateAdded: String

    private enum CodingKeys: String, CodingKey {
        case expense
        case category
        case note
        case dateAdded
    }

    init(expense: Double, category: String, note: String, dateAdded: Date) {
        self.expense = expense
        self.category = category
        self.note = note
        self.dateAdded = Expense.formatDate(date: dateAdded)
    }

    static func formatDate(date: Date) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm MMM dd,yyyy"
        return dateFormatterPrint.string(from: date)
    }
}
