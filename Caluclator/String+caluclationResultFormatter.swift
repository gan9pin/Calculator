//
//  String+calclationResultFormatter.swift
//  Calculator
//
//  Created by YutoTani on 2016/06/05.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import Foundation

extension String{
    
    static func calculationResultFormatter(value: Double) -> String{
 
        var result:String = String(value)
        
        //DoubleからStringに変換するときに指数表記されるのを回避
        if(result.rangeOfString("e") != nil && result.rangeOfString("+") == nil){
            var str:[String] = result.characters.split("-").map{String($0)} //指数を分割（7e-10 -> [7e,10])
            var upperSize = 0
            if(str[0].rangeOfString(".") != nil){
                let start = str[0].characters.indexOf(".")?.successor()
                let end = str[0].characters.indexOf("e")
                upperSize = str[0].substringWithRange(start!..<end!).characters.count
            }
            if(Int(str[1])! + upperSize < 15){
                print("before",value)
                result = String(format:"%.\(String(Int(str[1])! + upperSize))f",value)
                print(result)
            }
        }
        
        if(result.rangeOfString(".") != nil){
            let resultArray = result.characters.split(".").map{String($0)}
            if(resultArray[1] == "0"){result = resultArray[0]}
        }
        return result
    }
}