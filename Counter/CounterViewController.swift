//
//  ViewController.swift
//  Counter
//
//  Created by Tudor Croitoru on 21/04/2019.
//  Copyright © 2019 Tudor Croitoru. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var theme: Int = defaults?.integer(forKey: themeKey) ?? 0
    var index: Int!
    var counter: Counter?
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func back(_ sender: RoundedButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var initialValueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var resetButton: RoundedButton!
    
    @IBOutlet weak var initialValueButton: RoundedButton!
    @IBAction func setInitialValue(_ sender: RoundedButton) {
        
        let alert = UIAlertController(title: "Set the starting value", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.keyboardAppearance = .default
        }
        
        alert.addAction(.init(title: "OK", style: .default, handler: { [weak self] (_) in
            
            guard   let self = self,
                    let counter = self.counter else { return }
            
            if let val = Int(alert.textFields?[0].text ?? "0") {
                counter.initialVal = val
            }
            self.updateCounterLabel(count: counter.count)
            self.updateStartingLabel(startFrom: counter.initialVal)
            globalCounters[self.index] = counter
            Counter.writeCounterArrayToDefaults(counters: globalCounters)
            
        }))
        
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetCounter(_ sender: RoundedButton) {
        guard let counter = counter else { return }
        counter.count = 0
        globalCounters[index] = counter
        updateCounterLabel(count: counter.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let counter = counter else { return }
        
        setTheme(theme: Theme.theme(rawValue: theme) ?? .light)
        
        updateCounterLabel(count: counter.count)
        initialValueLabel.text = "Starting from: \(counter.initialVal)"
        instructionLabel.text = "Swipe sideways to \((counter.direction == 1) ? "decrement" : "increment")."
        titleLabel.text = counter.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counter = globalCounters[index]
        
        counterLabel.adjustsFontSizeToFitWidth = true
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(defaultGesture(sender:)))
        let swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(decrement(sender:)))
        
        //MARK: Setting up counter label font size
        let percentage: CGFloat = 0.4464
        let fontSize = view.frame.height * percentage
        counterLabel.font = counterLabel.font.withSize(fontSize)
        
        //MARK: Setting up gesture recognizers
        tapGR.delegate      = self
        swipeGR.delegate    = self
        
        
        swipeGR.direction = [.right, .left]
        
        view.addGestureRecognizer(tapGR)
        view.addGestureRecognizer(swipeGR)
        view.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Counter.writeCounterArrayToDefaults(counters: globalCounters)
    }
    
    @objc func defaultGesture(sender: UITapGestureRecognizer) {
        if  sender.state == .ended,
            let counter = counter {
            
            counter.primaryGesture(completion: nil)
            globalCounters[index] = counter
            updateCounterLabel(count: counter.count)
            
        }
    }
    
    @objc func decrement(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended,
            let counter = counter {
            counter.secondaryGesture(completion: nil)
            globalCounters[index] = counter
            updateCounterLabel(count: counter.count)
        }
    }

    func updateCounterLabel(count: Int) {
        guard let counter = counter else { return }
        
        counterLabel.text = String(counter.initialVal + counter.count)
        
        let colors = Theme.counterColours(theme: Theme.theme(rawValue: theme)!)
        
        self.counterLabel.textColor = ((counter.count + counter.initialVal) >= 0) ? colors[1] : colors[0]
    }
    
    func updateStartingLabel(startFrom: Int) {
        UIView.animate(withDuration: 0.2,
                       animations: { [weak self] in
                        
                        guard let self = self else { return }
                        
                        self.initialValueLabel.alpha = 0
        }) { [weak self] (success) in
            
            guard   let self = self,
                    let counter = self.counter else { return }
            
            self.initialValueLabel.text = "Starting from: \(counter.initialVal)"
            
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.initialValueLabel.alpha = 1
            })
            
        }
    }

}

extension CounterViewController {
    //shaky shaky
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            theme = (theme + 1) % 2
            setTheme(theme: Theme.theme(rawValue: theme)!)
        }
    }
    
    func setTheme(theme: Theme.theme) {
        
        guard let counter = counter else { return }
        
        let labelColour         = Theme.labelColour(theme: theme)
        let backgroundColour    = Theme.backgroundColour(theme: theme)
        let buttonColor         = Theme.buttonColor(theme: theme)
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            
            guard let self = self else { return }
            
            self.instructionLabel.textColor  = labelColour
            self.titleLabel.textColor        = labelColour
            self.initialValueLabel.textColor = labelColour
            self.initialValueButton.backCol  = labelColour
            self.backButton.tintColor        = labelColour
            
            self.view.backgroundColor        = backgroundColour
            self.resetButton.backCol         = buttonColor
            self.resetButton.setTitleColor((theme == Theme.theme.light) ? UIColor.white : UIColor.black, for: .normal)
        }
        
        updateCounterLabel(count: counter.count)
        
        defaults?.set(theme.rawValue, forKey: "theme")
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if theme == 0 {
            return .default
        }
        return .lightContent
    }
    
}
