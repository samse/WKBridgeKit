//
//  StringExtension.swift
//  HLFMOBRC
//
//  Created by ntoworks on 2022/06/15.
//

import UIKit

extension String {
    func color() -> UIColor? {
        if self.count == 6 {
            var start = self.index(self.startIndex, offsetBy: 0)
            var end = self.index(self.startIndex, offsetBy: 2)
            var range = start..<end
            let r = Int(self[range], radix: 16) ?? 0

            start = self.index(self.startIndex, offsetBy: 2)
            end = self.index(self.startIndex, offsetBy: 4)
            range = start..<end
            let g = Int(self[range], radix: 16) ?? 0
            
            start = self.index(self.startIndex, offsetBy: 4)
            end = self.index(self.startIndex, offsetBy: 6)
            range = start..<end
            let b = Int(self[range], radix: 16) ?? 0
            
            return UIColor(red: r, green: g , blue: b as Int, a: 255)
        } else {
            return nil
        }
    }
}
