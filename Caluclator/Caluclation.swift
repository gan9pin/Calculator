//
//  File.swift
//  Caluclator
//
//  Created by YutoTani on 2016/05/28.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import Foundation

class Caluclation{
    
    static var memoryPlus:Double = 0 //メモリープラスを格納
    static var memoryMinus:Double = 0 //メモリーマイナスを格納
    
    //userが行ったアクションのステート
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
        
        //変数に代入されるたびにカンマ区切りでフォーマットする。
        didSet{
            previousValue = String.commaFormatter(previousValue)
            
        }
    }
    static var currentValue:String = "0" {
        didSet{
            currentValue = String.commaFormatter(currentValue)
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
        let resultDouble = exp.expressionValueWithObject(nil, context: nil) as! Double
        
        var result:String = String(resultDouble)
        
        //DoubleからStringに変換するときに指数表記されるのを回避
        if(result.rangeOfString("e") != nil && result.rangeOfString("+") == nil){
            var str:[String] = result.characters.split("-").map{String($0)} //指数を分割（7e-10 -> [7e,10])
            if(Int(str[1]) < 15){
                result = String(format:"%.\(str[1])f",resultDouble)
            }
        }
        
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
            
            return previousValue
            
        default:
            
            if(currentValue == ""){ currentValue = "0"}
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
    
    //イコールを押した時のメソッド
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
    
    //%を押した時のメソッド
    static func persent() -> String{
        
        switch previousAction{
            
        case Action.Number,Action.Other:
            currentValue = eval(String(Double(currentValue)!), strOperator: "/", rightSide: "100")
            previousAction = Action.Other
            return currentValue
            
        case Action.Equal:
            previousValue = eval(String(Double(previousValue)!), strOperator: "/", rightSide: "100")
            return previousValue
            
        case Action.Point:
            currentValue = eval(String(Double(currentValue + "0")!), strOperator: "/", rightSide: "100")
            previousAction = Action.Other
            return currentValue
            
        default:
            previousAction = Action.Other
            return "0"
        }
    }
    
    //clearを押した時のメソッド
    static func clear() -> String{
        previousValue = "0"
        previousAction = Action.None
        lastOperator = ""
        currentValue = ""
        return previousValue
    }
        //関数電卓部分のメソッド
    static func scientificFunction(key: String, var labelValue: String) -> String {
        
        labelValue = labelValue.stringByReplacingOccurrencesOfString(",", withString: "")
        
        switch key{
            
        case "mc":
            memoryPlus = 0
            memoryMinus = 0
            clear()
            previousAction = Action.Other
            return String.commaFormatter(labelValue)
        case "m+":
            memoryPlus += Double(labelValue)!
            previousAction = Action.Other
            return String.commaFormatter(labelValue)
        case "m-":
            memoryMinus -= Double(labelValue)!
            previousAction = Action.Other
            return String.commaFormatter(labelValue)
        case "mr":
            clear()
            previousAction = Action.Equal
            previousValue = eval(String(memoryPlus), strOperator: "+",  rightSide: String(memoryMinus))
            return previousValue
            
        default:
            return labelValue
            
        }
    }
    
}