//
//  ViewController.swift
//  Expensr
//
//  Created by Dabrowski,Brendyn on 12/22/19.
//  Copyright © 2019 BDCreative. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    public static let updatedExpensesNotification = Notification.Name("updatedExpenses")

    private let userDefaults = UserDefaults.standard

    private let categories = ["Food", "Groceries", "Misc", "Gas", "OTB"]

    private var currentSelectedCategory: String = "Food"

    // MARK: - Top Labels

    @IBOutlet weak var totalExpensesLabel: UILabel!

    @IBOutlet weak var cashBalanceLabel: UILabel!

    @IBOutlet weak var addExpenseTextField: UITextField!

    @IBOutlet weak var memoTextField: UITextField!

    @IBOutlet weak var categoryPickerView: UIPickerView!

    @IBOutlet weak var shouldDivideByTwoSwitch: UISwitch!

    // MARK: - Bottom Label

    @IBOutlet weak var foodLabel: UILabel!

    @IBOutlet weak var groceriesLabel: UILabel!

    @IBOutlet weak var miscLabel: UILabel!

    @IBOutlet weak var gasLabel: UILabel!

    @IBOutlet weak var otbLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapGesture()
        self.clearTextFields()
        self.loadExpensesView()
        self.setupPickerViewDelegate()
        self.turnOffSwitch()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateAllLabels(_:)),
                                               name: Self.updatedExpensesNotification,
                                               object: nil)
    }


    @IBAction func submit(_ sender: UIButton) {
        guard let submittedExpense = self.addExpenseTextField.text,
            let submittedMemo = self.memoTextField.text else {
                return
        }

        guard var submittedExpenseDouble = Double(submittedExpense) else {
            self.presentNotANumberAlert()
            return
        }

        if self.shouldDivideByTwoSwitch.isOn {
            submittedExpenseDouble = submittedExpenseDouble / 2
        }

        let expense = Expense(expense: submittedExpenseDouble, category: self.currentSelectedCategory, note: submittedMemo, dateAdded: Date())
        Expenses.shared.add(expense) {
            self.updateLabel(for: expense)
            self.updateTotalLabels()
            self.clearTextFields()
        }

        NotificationCenter.default.post(name: Self.updatedExpensesNotification, object: nil)
    }

    @objc
    func updateAllLabels(_ notification: Notification) {
        self.updateAllExpenseLabels()
        self.updateTotalLabels()
    }


    @IBAction func reset(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?",
                                      message: "This will clear all expenses and you won't be able to recover them.",
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            Expenses.shared.resetExpenses() {
                self.resetLabels()
                self.clearTextFields()
                self.turnOffSwitch()
            }

            NotificationCenter.default.post(name: Self.updatedExpensesNotification, object: nil)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Picker View Methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentSelectedCategory = self.categories[row]
    }

    func setupPickerViewDelegate() {
        self.categoryPickerView.dataSource = self
        self.categoryPickerView.delegate = self
    }

    // MARK: - Helper Methods

    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
    }

    func clearTextFields() {
        self.addExpenseTextField.text = ""
        self.memoTextField.text = ""
    }

    func turnOffSwitch() {
        self.shouldDivideByTwoSwitch.isOn = false
    }

    func loadExpensesView() {
        self.totalExpensesLabel.text = self.formatLabel(for: Expenses.shared.totalExpenses)
        self.cashBalanceLabel.text = self.formatLabel(for: Expenses.shared.cashBalance)

        self.foodLabel.text = self.formatLabel(for: Expenses.shared.foodExpenses)
        self.groceriesLabel.text = self.formatLabel(for: Expenses.shared.groceriesExpenses)
        self.miscLabel.text = self.formatLabel(for: Expenses.shared.miscExpenses)
        self.gasLabel.text = self.formatLabel(for: Expenses.shared.gasExpenses)
        self.otbLabel.text = self.formatLabel(for: Expenses.shared.otbExpenses)
    }

    func presentNotANumberAlert() {
        let alert = UIAlertController(title: "Did not enter a number",
                                      message: "Please enter a number",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    func formatLabel(for expense: Double) -> String {
        return "$" + String(format: "%.2f", expense)
    }

    func updateLabel(for expense: Expense) {
       switch expense.category {
            case "Food":
                self.foodLabel.text = self.formatLabel(for: Expenses.shared.foodExpenses)
            case "Groceries":
                self.groceriesLabel.text = self.formatLabel(for: Expenses.shared.groceriesExpenses)
            case "Misc":
                self.miscLabel.text = self.formatLabel(for: Expenses.shared.miscExpenses)
            case "Gas":
                self.gasLabel.text = self.formatLabel(for: Expenses.shared.gasExpenses)
            case "OTB":
                self.otbLabel.text = self.formatLabel(for: Expenses.shared.otbExpenses)
        default:
            break
        }
    }

    func updateAllExpenseLabels() {
        self.foodLabel.text = self.formatLabel(for: Expenses.shared.foodExpenses)
        self.groceriesLabel.text = self.formatLabel(for: Expenses.shared.groceriesExpenses)
        self.miscLabel.text = self.formatLabel(for: Expenses.shared.miscExpenses)
        self.gasLabel.text = self.formatLabel(for: Expenses.shared.gasExpenses)
        self.otbLabel.text = self.formatLabel(for: Expenses.shared.otbExpenses)
    }

    func updateTotalLabels() {
        self.cashBalanceLabel.text = self.formatLabel(for: Expenses.shared.cashBalance)
        self.totalExpensesLabel.text = self.formatLabel(for: Expenses.shared.totalExpenses)

        if Expenses.shared.cashBalance <= 100 {
            self.cashBalanceLabel.textColor = UIColor.red
        } else {
            self.cashBalanceLabel.textColor = UIColor.black
        }
    }

    func resetLabels() {
        self.foodLabel.text = self.formatLabel(for: 0)
        self.groceriesLabel.text = self.formatLabel(for: 0)
        self.miscLabel.text = self.formatLabel(for: 0)
        self.gasLabel.text = self.formatLabel(for: 0)
        self.otbLabel.text = self.formatLabel(for: 0)

        self.clearTextFields()
        self.updateTotalLabels()
    }
}

