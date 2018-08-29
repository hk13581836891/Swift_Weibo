//
//  String+Extension.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/29.
//  Copyright © 2018年 houke. All rights reserved.
//

import Foundation

extension String {
    func mySubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func mySubString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
}
