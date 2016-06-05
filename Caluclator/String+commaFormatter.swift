//
//  String+.swift
//  Caluclator
//
//  Created by YutoTani on 2016/06/02.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import Foundation


extension String{
    
    //文字列の数字を三桁ごとにカンマ区切りにする
    static func commaFormatter(var value:String) -> String{
        
        if(value == ""){return ""}
        if(value.rangeOfString("-") != nil){ return value}
        
        var integer:String = ""  //整数部分を格納する
        var smallNumber:String = ""  //小数点以下を格納する
        var comma:String = ""
        
        value = value.stringByReplacingOccurrencesOfString(",", withString: "")  //すでにカンマで区切られている場合は一旦取り除く
        
        //小数点以下が存在する場合で、最後の値がカンマでない場合
        if(value.rangeOfString(".") != nil && value.substringFromIndex(value.startIndex.advancedBy(value.characters.count - 1)) != "."){
            let split = value.characters.split(".").map{String($0)}
            print(split)
            integer = split[0]
            smallNumber = split[1]
            comma = "."
        }
            //最後の値がカンマの場合
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