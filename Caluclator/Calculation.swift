//
//  File.swift
//  Calculator
//
//  Created by YutoTani on 2016/05/28.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import Foundation
import UIKit

class Calculation{
    
    var memoryPlus:Double = 0 //メモリープラスを格納
    var memoryMinus:Double = 0 //メモリーマイナスを格納
    
    //userが行ったアクションのステート
    enum Action{
        case None
        case Number
        case Point
        case Operator
        case Equal
        case Other
    }
    
    var previousAction = Action.None
    
    var previousValue:String = "0" {
        
        //変数に代入されるたびにカンマ区切りでフォーマットする。
        didSet{
            previousValue = String.commaFormatter(previousValue)
            
        }
    }
    var currentValue:String = "0" {
        didSet{
            currentValue = String.commaFormatter(currentValue)
        }
    }
    
    var lastOperator = "" //最後に押した四則演算子を保持する
    
    //番号を追加するメソッド
    func addNumber(number:String) -> String{
        
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
        
        // 現在のデバイスの向きを取得.
        let deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
        
        var countNumber = currentValue.stringByReplacingOccurrencesOfString(",", withString: "")
        countNumber = countNumber.stringByReplacingOccurrencesOfString(".", withString: "")
        // 横向き
        if (UIDeviceOrientationIsLandscape(deviceOrientation)){
            if (countNumber.characters.count < 16){
                currentValue = currentValue + number
                return currentValue
            }
            else{
                return currentValue
            }
            
        }
        // 縦向き
        else{
            if (countNumber.characters.count < 9){
                currentValue = currentValue + number
                return currentValue
            }
            else{
                return currentValue
            }
        }
    }
    
    func addPoint() -> String{
        
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
    func addSign() -> String{
        
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
    func addOperator(var strOperator:String) -> String{
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
                previousValue = String.eval(previousValue,operatorArg: lastOperator, rightSide: currentValue)
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
    func equal() -> String{
        
        switch previousAction{
            
        case Action.Number, Action.Equal, Action.Other:
            previousValue = String.eval(previousValue, operatorArg: lastOperator ,rightSide: currentValue)
            
        case Action.Point:
            currentValue.removeAtIndex(currentValue.startIndex.advancedBy(currentValue.characters.count - 1))
            previousValue = String.eval(previousValue, operatorArg: lastOperator ,rightSide: currentValue)
            
        case Action.Operator:
            currentValue = previousValue
            previousValue = String.eval(previousValue, operatorArg: lastOperator ,rightSide: currentValue)
        default:
            break

        }
        previousAction = Action.Equal
        
        return previousValue
        
    }
    
    //%を押した時のメソッド
    func persent() -> String{
        
        currentValue = currentValue.stringByReplacingOccurrencesOfString(",", withString: "")
        
        switch previousAction{
            
        case Action.Number,Action.Other:
            currentValue = String.eval(currentValue, operatorArg: "/", rightSide: "100")
            previousAction = Action.Other
            return currentValue
            
        case Action.Equal:
            previousValue = String.eval(previousValue, operatorArg: "/", rightSide: "100")
            return previousValue
            
        case Action.Point:
            currentValue = String.eval(currentValue + "0", operatorArg: "/", rightSide: "100")
            previousAction = Action.Other
            return currentValue
            
        default:
            previousAction = Action.Other
            return "0"
        }
    }
    
    //clearを押した時のメソッド
    func clear() -> String{
        previousValue = "0"
        previousAction = Action.None
        lastOperator = ""
        currentValue = ""
        return previousValue
    }
        //関数電卓部分のメソッド
    func scientificFunction(key: String, var labelValue: String) -> String {
        
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
            previousValue = String.eval(String(memoryPlus), operatorArg: "+",  rightSide: String(memoryMinus))
            return previousValue
        case "x²":
            currentValue = String.calculationResultFormatter(pow(Double(currentValue)!, 2.0))
            return currentValue
        case "x³":
            currentValue = String.calculationResultFormatter(pow(Double(currentValue)!, 3.0))
            return currentValue
            
            
        default:
            return labelValue
            
        }
    }
    
}