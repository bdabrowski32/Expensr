//
//  ExpenseHistoryViewController.swift
//  Expensr
//
//  Created by Dabrowski,Brendyn on 12/22/19.
//  Copyright © 2019 BDCreative. All rights reserved.
//

import UIKit

class ExpenseHistoryViewController: UITableViewController {

    var expenses = [Expense]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()

        tableView.delegate = self
        tableView.dataSource = self

        self.expenses = Expenses.shared.expensesArray

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateExpenses(_:)),
                                               name: AddExpenseViewController.updatedExpensesNotification,
                                               object: nil)
    }

    @objc
    func updateExpenses(_ notification: Notification) {
        self.expenses = Expenses.shared.expensesArray
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ExpenseHistoryCell else {
                return UITableViewCell(frame: .zero)
        }

        let expenseObjects = self.expenses[indexPath.row]

        cell.expenseLabel.text = "$" + String(format: "%.2f", expenseObjects.expense)
        cell.categoryLabel.text = expenseObjects.category
        cell.dateLabel.text = expenseObjects.dateAdded
        cell.noteLabel.text = expenseObjects.note
        
        return cell
    }

    func setupTableView() {
        self.tableView.rowHeight = 80
    }
}
