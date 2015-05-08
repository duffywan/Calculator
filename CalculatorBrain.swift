//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Duffy Wan on 5/8/15.
//  Copyright (c) 2015 Duffy Wan. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op : Printable{
        case Operand (Double)
        case UnaryOperation ( String, Double -> Double)
        case BinaryOperation (String, (Double, Double) -> Double)
        
        var description : String{
            get {
                switch self {
                case .Operand(let operand) :
                    return "\(operand)"
                case .UnaryOperation(let symbol, _) :
                    return symbol
                case .BinaryOperation(let symbol, _) :
                    return symbol
                }
            }
        }
    }
    private var opStack = [Op]() // or opStack = [Op]
    
    private var knownOps = [String:Op]()
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
    }
    
    func evaluate () -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    private func evaluate (ops : [Op]) -> (result : Double?, remainingOps : [Op]) { // pass by value, array and dictionary are struc in SWIFT
        // struct are passed by value and class are passed by reference
        // if we pass ops like ops : [Op] then the parameter is default read-only
        // a read only array is immutable
        // cannot call removelast on ops
        // so we put var before ops:[Op] then we can mutate the array
        // it's preferrable to define a local variable equals to ops.
        // when using =, the local variable make a copy of it. and since we define the local variable to be var
        // then it is mutable
        println(ops)
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation) :
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation) :
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
            
        }
        return (nil, ops)
    }
    
    func pushOperand (operand : Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation (symbol : String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
            return evaluate()
        }
        return nil
    }
    
    func clear () {
        opStack.removeAll(keepCapacity: false)
    }
    
}