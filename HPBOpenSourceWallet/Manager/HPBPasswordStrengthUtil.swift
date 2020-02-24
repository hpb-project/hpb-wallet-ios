//
//  HPBPasswordStrengthUtil.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/15.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation

class  HPBPasswordStrengthUtil{
    
    enum PasswordStrength{
        case weak,middle,strong,none
    }
    private static let termArray1 = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    private static let termArray2 = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    private static let termArray3 = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    private static let termArray4 = ["~","`","@ ","#","$","%","^","&","*","(",")","-","_","+","=","{","}","[","]","|",":",";","“","'","‘","<",",",".",">","?","/","、"," "]
    
   static func judgePasswordStrength(password: String) -> PasswordStrength{
        
        let allArr = [termArray1,termArray2,termArray3,termArray4]
        var resultArr: [Bool] = []
        for item in allArr{
            resultArr.append(judgeWithArr(arr: item, password))
        }
        resultArr  =  resultArr.filter { return $0 == true }
        if password.count == 0 {
            return .none
        }else if password.count < 8{
            return .weak
        }else if resultArr.count == 1{
            return .weak
        }else if resultArr.count == 2{
            return .middle
        }else if resultArr.count > 2{
            return .strong
        }else{
            return .weak
        }
    }
    
    fileprivate static func judgeWithArr(arr: [String], _ password: String) -> Bool{
        for i in 0..<arr.count{
            if password.contains(arr[i]){
                return true
            }
        }
        return false
    }
    
    static func  verificatPassword(_ password: String) -> Bool{
        if password.count < 8{
            return false
        }
        return true
    }
    
    static func  verificatMaxPassword(_ password: String) -> Bool{
        if password.count > 20{
            return false
        }
        return true
    }
    
}
