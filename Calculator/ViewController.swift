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
    
    // all variables have to be initialized
    var userIsInTheMiddleOfTypingANumber = false
    
    var pointAppended = false
    
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
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
            userIsInTheMiddleOfTypingANumber = false
        }
        switch operation {
        case "×" : performOperation { $0 * $1 }
        case "−" : performOperation { $0 - $1 }
        case "+" : performOperation { $0 + $1 }
        case "÷" : performOperation { $0 / $1 }
        case "√" : performOperation { sqrt($0) }
        case "sin" : performOperation { sin($0) }
        case "cos" : performOperation { cos($0) }
        default: break
        }
    }
    func multiply(op1 : Double, op2 : Double) -> Double {
        return op1 * op2
    }
    
    func performOperation(operation : (Double, Double) -> Double){
        if (operandStack.count >= 2) {
            displayValue  = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    private func performOperation(operation : Double -> Double){
        if (operandStack.count >= 1) {
            displayValue  = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        pointAppended = false
        // if the user click the point and then enter, the calculator does nothing
        if display.text! != "." {
            operandStack.append(displayValue)
        }
        println(operandStack)
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


