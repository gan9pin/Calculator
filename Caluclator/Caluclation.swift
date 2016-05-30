//
//  File.swift
//  Caluclator
//
//  Created by YutoTani on 2016/05/28.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import Foundation

class Caluclation{
    
    var memoryPlus:String = "" //メモリープラスを格納
    var momeryMinus:String = "" //メモリーマイナスを格納
    var results:String = "" //計算結果
    static var previousValue:String = "0"
    static var currentValue:String = "0"
    static var lastOperator = "" //最後に押した四則演算子を保持する
    
    enum Action{
        case None
        case Number
        case Point
        case Operator
        case Equal
        case Other
    }
    static var previousAction = Action.None
    
    //文字列の式を評価するメソッド
    static func eval(stringformula:String) -> String{
        let exp: NSExpression = NSExpression(format: stringformula)
        let result: Double = exp.expressionValueWithObject(nil, context: nil) as! Double
        
        return String(result)
    }
    
    //番号を追加するメソッド
    static func addNumber(number:String) -> String{
        
        print("addNumber")
        switch previousAction{
            
        case Action.None, Action.Equal:
            lastOperator = ""
            currentValue = ""
            
        case Action.Operator:
            currentValue = ""
            
        default:
            break
            
        }
        previousAction = Action.Number
        
        currentValue = currentValue + number
        
        return currentValue
    }
    
    static func addPoint() -> String{
        print("addPoint")
        switch previousAction{
            
        case Action.Operator, Action.Equal, Action.None:
            currentValue = "0."
            
        default:
            currentValue = currentValue + "."
        }
        previousAction = Action.Point
        return currentValue
        
    }
    
    //符号を追加・削除
    static func addSign() -> String{
        
        switch previousAction{
            
        case Action.Equal:
            
            if(previousValue[previousValue.startIndex] == "-"){
                previousValue.removeAtIndex(previousValue.startIndex)
            }
            else{
                previousValue = "-" + previousValue
            }
            
            previousAction = Action.Other
            return previousValue
            
        default:
            
            if(currentValue[currentValue.startIndex] == "-"){
                currentValue.removeAtIndex(currentValue.startIndex)
            }
            else{
                currentValue = "-" + currentValue
            }
            
            previousAction = Action.Other
            return currentValue
        }
    }
    
    //四則演算子を式に追加する
    static func addOperator(var strOperator:String) -> String{
        print("addOperator")
        if(strOperator == "×"){strOperator = "*"}
        if(strOperator == "÷"){strOperator = "/"}
        
        
        switch previousAction{
            
        case Action.None, Action.Equal:
            previousValue = "0"
            lastOperator = strOperator
            
        case Action.Operator:
            lastOperator = strOperator
            
        case Action.Number,Action.Other:
            //lastOperatorにすでに式が代入されている場合は前の式を先に評価する
            if(lastOperator != ""){
                previousValue = eval(previousValue + lastOperator + currentValue)
            }
            //まだ演算子が入力されていない場合
            else{
                previousValue = currentValue
            }
            lastOperator = strOperator
            
        default:
            break
        }
        
        previousAction = Action.Operator
        
        return previousValue
    }
    
    static func equal() -> String{
        
        switch previousAction{
            
        case Action.Number, Action.Equal, Action.Other:
            previousValue = eval(previousValue + lastOperator + currentValue)
            
        case Action.Point:
            currentValue.removeAtIndex(currentValue.endIndex)
            previousValue = eval(previousValue + lastOperator + currentValue)
            
        case Action.Operator:
            currentValue = previousValue
            previousValue = eval(previousValue + lastOperator + currentValue)
        default:
            break

        }
        previousAction = Action.Equal
        
        return previousValue
        
    }
    static func persent() -> String{
        if(previousAction == Action.Number){
            currentValue = String(Double(currentValue)! / 100.0)
            return currentValue
        }
        else if(previousAction == Action.Equal){
            previousValue = String(Double(previousValue)! / 100.0)
            return previousValue
        }
        else{
            return "0"
        }
    }
    static func clear() -> String{
        previousValue = "0"
        previousAction = Action.None
        lastOperator = ""
        
        return previousValue
    }
    
}