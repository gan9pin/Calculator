//
//  String+eval.swift
//  Caluclator
//
//  Created by YutoTani on 2016/06/05.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import Foundation

extension String{
    
    static func eval(leftSide: String, operatorArg: String, var rightSide: String) -> String{
        
        //  左辺か右辺いずれかがDouble型でないと正しい結果が出ないため、右辺は確実にDouble型で計算する　例）1 / 9 = 0
        if(rightSide.rangeOfString(".") == nil){
            rightSide = rightSide + ".0"
        }
        var stringFormula = leftSide + operatorArg + rightSide
        stringFormula = stringFormula.stringByReplacingOccurrencesOfString(",", withString: "")
        let exp: NSExpression = NSExpression(format: stringFormula)
        let resultDouble = exp.expressionValueWithObject(nil, context: nil) as! Double
        
        print("resultDouble",resultDouble)
        return calculationResultFormatter(resultDouble)
    }
}