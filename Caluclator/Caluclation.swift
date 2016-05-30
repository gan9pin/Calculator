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
    
    enum Action{
        case None
        case Number
        case Point
        case Operator
        case Equal
        case Other
    }
    
    static var previousAction = Action.None
    
    static var previousValue:String = "0" {
        didSet{
            previousValue = StringValueFormat(previousValue)
            
        }
    }
    static var currentValue:String = "0" {
        didSet{
            currentValue = StringValueFormat(currentValue)
        }
    }
    static var lastOperator = "" //最後に押した四則演算子を保持する
    
    //文字列の式を評価するメソッド
    static func eval(leftSide:String, strOperator:String, var rightSide: String) -> String{
        
        //  左辺か右辺いずれかがDouble型でないと正しい結果が出ないため、右辺は確実にDouble型で計算する　例）1 / 9 = 0
        if(rightSide.rangeOfString(".") == nil){
            rightSide = rightSide + ".0"
        }
        var stringFormula = leftSide + strOperator + rightSide
        stringFormula = stringFormula.stringByReplacingOccurrencesOfString(",", withString: "")
        let exp: NSExpression = NSExpression(format: stringFormula)
        var result: String = String(exp.expressionValueWithObject(nil, context: nil) as! Double)
        if(result.rangeOfString(".") != nil){
            let resultArray = result.characters.split(".").map{String($0)}
            if(resultArray[1] == "0"){result = resultArray[0]}
        }
        else if(result == "inf" || result == "nan"){
            result = "エラー"
            clear()
        }
        return result
    }
    
    //番号を追加するメソッド
    static func addNumber(number:String) -> String{
        
        print("addNumber")
        switch previousAction{
            
        case Action.None, Action.Equal, Action.Other:
            lastOperator = ""
            currentValue = ""
            
        case Action.Operator:
            currentValue = ""
            
        default:
            break
            
        }
        previousAction = Action.Number
        if(currentValue == "0"){currentValue = ""}
        currentValue = currentValue + number
        
        return currentValue
    }
    
    static func addPoint() -> String{
        print("addPoint")
        if(currentValue.rangeOfString(".") != nil){ return currentValue }
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
            
        case Action.None:
            previousValue = "0"
            lastOperator = strOperator
            
        case Action.Operator, Action.Equal:
            lastOperator = strOperator
            
        case Action.Number,Action.Other:
            //lastOperatorにすでに式が代入されている場合は前の式を先に評価する
            if(lastOperator != ""){
                previousValue = eval(previousValue, strOperator: lastOperator ,rightSide: currentValue)
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
            previousValue = eval(previousValue, strOperator: lastOperator ,rightSide: currentValue)
            
        case Action.Point:
            currentValue.removeAtIndex(currentValue.endIndex)
            previousValue = eval(previousValue, strOperator: lastOperator ,rightSide: currentValue)
            
        case Action.Operator:
            currentValue = previousValue
            previousValue = eval(previousValue, strOperator: lastOperator ,rightSide: currentValue)
        default:
            break

        }
        previousAction = Action.Equal
        
        return previousValue
        
    }
    
    static func persent() -> String{
        
        switch previousAction{
            
        case Action.Number:
            currentValue = eval(String(Double(currentValue)!), strOperator: "/", rightSide: "100")
            previousAction = Action.Point
            return currentValue
            
        case Action.Equal:
            previousValue = eval(String(Double(previousValue)!), strOperator: "/", rightSide: "100")
            previousAction = Action.Point
            return previousValue
            
        case Action.Point:
            currentValue = eval(String(Double(currentValue + "0")!), strOperator: "/", rightSide: "100")
            previousAction = Action.Point
            return currentValue
            
        default:
            previousAction = Action.Other
            return "0"
        }
    }
    
    static func clear() -> String{
        previousValue = "0"
        previousAction = Action.None
        lastOperator = ""
        currentValue = ""
        return previousValue
    }
    
    static func StringValueFormat(var value:String) -> String{
        
        if(value == ""){return ""}
        var integer:String = ""
        var smallNumber:String = ""
        var comma:String = ""
        
        value = value.stringByReplacingOccurrencesOfString(",", withString: "")
        print(value)
        if(value.rangeOfString(".") != nil && value.substringFromIndex(value.startIndex.advancedBy(value.characters.count - 1)) != "."){
            let split = value.characters.split(".").map{String($0)}
            print(split)
            integer = split[0]
            smallNumber = split[1]
            comma = "."
            
        }
        else if(value.substringFromIndex(value.startIndex.advancedBy(value.characters.count - 1)) == "."){
            print(value)
            value.removeAtIndex(value.startIndex.advancedBy(value.characters.count - 1))
            integer = value
            comma = "."
            
        }else{
            integer = value
        }
        
        let result:String?
        if(integer.characters.count > 3){
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            
            result = formatter.stringFromNumber(NSNumber(integer:Int(integer)!))
        }
        else{
            result = integer
        }
        
        return String(result!) + comma + smallNumber
    }
    
}