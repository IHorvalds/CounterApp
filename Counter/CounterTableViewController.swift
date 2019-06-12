//
//  CounterTableViewController.swift
//  Counter
//
//  Created by Tudor Croitoru on 29/05/2019.
//  Copyright © 2019 Tudor Croitoru. All rights reserved.
//

import UIKit

class CounterTableViewController: UITableViewController {
    
    var theme: Int = defaults?.integer(forKey: themeKey) ?? 0
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBAction func addCounter(_ sender: UIBarButtonItem) {
        
        var success = false
        
        //show modal to get initialvalue and direction
        let dialog = UIAlertController(title: "Create a new counter", message: nil, preferredStyle: .alert)
        
        dialog.addTextField { (textField) in
            textField.borderStyle = .roundedRect
            textField.placeholder = "Name"
        }
        
        dialog.addTextField { (textField) in
            textField.borderStyle = .roundedRect
            textField.placeholder = "Starting value"
            textField.keyboardType = .numberPad        }
        
        dialog.addAction(.init(title: "Add increasing counter", style: .default, handler: { [weak self] (_) in
            
            guard let textfields = dialog.textFields else { return }
            
            let name = (!textfields[0].hasText) ? "Counter" : textfields[0].text!
            let initValString = (!textfields[1].hasText) ? "0" : textfields[1].text!
            
            if let initVal = Int(initValString) {
                let c = Counter(title: name, direction: 1, initialVal: initVal)
                globalCounters.append(c)
                success = true
            }
            self?.addNewCounter(success)
            
            
        }))
        
        dialog.addAction(.init(title: "Add decreasing counter", style: .default, handler: { [weak self] (_) in
            
            guard let textfields = dialog.textFields else { return }
            
            let name = (!textfields[0].hasText) ? "Counter" : textfields[0].text!
            let initValString = (!textfields[1].hasText) ? "0" : textfields[1].text!
            
            if let initVal = Int(initValString) {
                let c = Counter(title: name, direction: -1, initialVal: initVal)
                globalCounters.append(c)
                success = true
            }
            self?.addNewCounter(success)
            
        }))
        
        dialog.addAction(.init(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(dialog, animated: true, completion: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.theme = defaults?.integer(forKey: themeKey) ?? 0
        setTheme(theme: Theme.theme(rawValue: theme)!, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        if #available(iOS 9.1, *) {
//            searchController.obscuresBackgroundDuringPresentation = false
//        } else {
//            // Fallback on earlier versions
//        }
//        searchController.searchBar.placeholder = "Search counters"
//        if #available(iOS 11.0, *) {
//            navigationItem.searchController = searchController
//        } else {
//            // Fallback on earlier versions
//        }
//        definesPresentationContext = true
        
        
        view.backgroundColor = Theme.groupedTableViewBackground(theme: Theme.theme(rawValue: theme)!)
        navigationController?.navigationBar.barStyle = Theme.navBarColor(theme: Theme.theme(rawValue: theme)!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalCounters.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countercell", for: indexPath) as! CounterCell
        
        cell.backgroundColor = Theme.backgroundColour(theme: Theme.theme(rawValue: theme)!)
        
        let index       = indexPath.row
        let counter     = globalCounters[index]
        let counterVal  = counter.initialVal + counter.count

        // Cell text
        cell.titleLabel.text        = counter.title + "(\((counter.direction == 1) ? "+" : "-"))" + ":"
        cell.valueLabel.text        = String(counterVal)
        
        //Cell colours
        let themeVal        = Theme.theme(rawValue: theme) ?? Theme.theme.light
        
        cell.backgroundColor = Theme.backgroundColour(theme: themeVal)
        cell.titleLabel.textColor = Theme.labelColour(theme: themeVal)
        let colors = Theme.counterColours(theme: themeVal)
        cell.valueLabel.textColor = ((counter.count + counter.initialVal) < 0) ? colors[0] : colors[1]
        

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            globalCounters.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            Counter.writeCounterArrayToDefaults(counters: globalCounters)
        }
    }

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let counterToMove = globalCounters.remove(at: fromIndexPath.row)
        globalCounters.insert(counterToMove, at: to.row)
        
    }
    
    fileprivate func addNewCounter(_ success: Bool) {
        if !success {
            let alert = UIAlertController(title: "Something went wrong", message: "Please enter a valid name and initial value.", preferredStyle: .alert)
            
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            Counter.writeCounterArrayToDefaults(counters: globalCounters)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showcounter",
            let destVC = segue.destination as? CounterViewController,
            let sender = sender as? CounterCell,
            let index = tableView.indexPath(for: sender) {

            destVC.index = index.row
            destVC.transitioningDelegate = self
            
        }
        
    }

}

extension CounterTableViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            theme = (theme + 1) % 2
            setTheme(theme: Theme.theme(rawValue: theme)!, animated: true)
        }
    }
    
    func setTheme(theme: Theme.theme, animated: Bool) {
        defaults?.set(theme.rawValue, forKey: "theme")
        setNeedsStatusBarAppearanceUpdate()
        if animated {
            UIView.transition(with: tableView,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                guard let self = self else { return }
                                self.tableView.reloadData()
                                self.view.backgroundColor = Theme.groupedTableViewBackground(theme: theme)
                                self.navigationController?.navigationBar.barStyle = Theme.navBarColor(theme: theme)
                                self.editButtonItem.tintColor = Theme.buttonColor(theme: theme)
                                self.addButton.tintColor = Theme.buttonColor(theme: theme)
                                
                }, completion: nil)
        } else {
            self.tableView.reloadData()
            self.view.backgroundColor = Theme.groupedTableViewBackground(theme: theme)
            self.navigationController?.navigationBar.barStyle = Theme.navBarColor(theme: theme)
            self.editButtonItem.tintColor = Theme.buttonColor(theme: theme)
            self.addButton.tintColor = Theme.buttonColor(theme: theme)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if theme == 0 {
            return .default
        }
        return .lightContent
    }
}

extension CounterTableViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if  let index   = tableView.indexPathForSelectedRow,
            let cell    = tableView.cellForRow(at: index) as? CounterCell {
            
            let rectInTable = tableView.rectForRow(at: index)
            let rectOfCellInSuperview = tableView.convert(rectInTable, to: tableView.superview)
            let titleFrameTmp = cell.convert(cell.titleLabel.frame, to: tableView)
            let countFrameTmp = cell.convert(cell.valueLabel.frame, to: tableView)
            let titleFrame = tableView.convert(titleFrameTmp, to: tableView.superview)
            let countFrame = tableView.convert(countFrameTmp, to: tableView.superview)
            
            return ExpandAnimationController(sender: cell,
                                             originFrame: rectOfCellInSuperview,
                                             titleFrame: titleFrame,
                                             countFrame: countFrame,
                                             title: globalCounters[index.row].title)
            
        }
        
        return nil
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if  let index   = tableView.indexPathForSelectedRow,
            let cell    = tableView.cellForRow(at: index) as? CounterCell {
        
            let rectInTable = tableView.rectForRow(at: index)
            let rectOfCellInSuperview = tableView.convert(rectInTable, to: tableView.superview)
            let titleFrameTmp = cell.convert(cell.titleLabel.frame, to: tableView)
            let countFrameTmp = cell.convert(cell.valueLabel.frame, to: tableView)
            let titleFrame = tableView.convert(titleFrameTmp, to: tableView.superview)
            let countFrame = tableView.convert(countFrameTmp, to: tableView.superview)
        
            
            return DismissAnimationController(sender: cell,
                                              originFrame: rectOfCellInSuperview,
                                              titleFrame: titleFrame,
                                              countFrame: countFrame,
                                              title: globalCounters[index.row].title)
        }
        
        return nil
    }
}

extension CounterTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
