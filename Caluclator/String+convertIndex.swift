//
//  String+convertIndex.swift
//  Caluclator
//
//  Created by YutoTani on 2016/06/08.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import Foundation

extension String{
    static func convertIndex(str:String) -> String{
        
        let dbl:Double = Double(str.stringByReplacingOccurrencesOfString(",", withString: ""))!
        var result = String(format:"%e",dbl)
        print(result)
        if(result.rangeOfString("e") != nil){
            print("find")
            // eより前の数字が0だったら削除する
            var pos = result.characters.indexOf("e")?.predecessor()
            while(result[pos!] == "0"){
                result.removeAtIndex(pos!)
                pos = pos?.predecessor()
                if(result[pos!] == "."){
                    result.removeAtIndex(pos!)
                    break
                }
            }
        }
        
        return result
    }
}