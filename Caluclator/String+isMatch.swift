//
//  String+isMatch.swift
//  Caluclator
//
//  Created by YutoTani on 2016/05/28.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import Foundation

extension String {
    func isMatch(pattern: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        let matches = regex?.matchesInString(self, options: NSMatchingOptions.Anchored, range: NSRange(location: 0, length: self.characters.count))
        return matches?.count > 0
    }
}