//
//  ViewController.swift
//  Calculator
//
//  Created by Duffy Wan on 5/2/15.
//  Copyright (c) 2015 Duffy Wan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    // all variables have to be initialized
    var userIsInTheMiddleOfTypingANumber = false
    
    var pointAppended = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {

        //let digit = sender.currentTitle; // digit is an optional that can be a string
        let digit = sender.currentTitle! // digit is a string
        if digit == "π" {
            display.text = "π"
            userIsInTheMiddleOfTypingANumber = false
        } else if userIsInTheMiddleOfTypingANumber {
            if digit != "." || !pointAppended {
                display.text! += digit
                pointAppended = true
            }
        } else {
            display.text = digit;
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func clear() {
        displayValue  = 0
        brain.clear()
    }
    
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
            userIsInTheMiddleOfTypingANumber = false
        }
        if let result = brain.performOperation(operation) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
/*
        // display the operator in the history label
        history.text! += history.text! == "" ? operation: " " + operation
*/


    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        pointAppended = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
/*
        // if the user click the point and then enter, the calculator does nothing
        if display.text! != "." {
            operandStack.append(displayValue)
            history.text! += history.text! == "" ? display.text! : " " + display.text!
        }
        println(operandStack)
*/
    }
    var displayValue: Double {
        get {
            return display.text == "π" ? M_PI :NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
        }
    }

}


