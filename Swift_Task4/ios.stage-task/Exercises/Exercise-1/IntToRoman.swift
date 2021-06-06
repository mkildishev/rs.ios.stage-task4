import Foundation

public extension Int {
    
    private var intToRoman: Dictionary<Int, String> {
        [1 : "I", 4 : "IV", 5 : "V", 9 : "IX", 10 : "X", 40 : "XL", 50 : "L", 90 : "XC", 100 : "C", 400 : "CD", 500 : "D", 900 : "CM", 1000 : "M"]
    }
    
    var roman: String? {
        if 1 > self || self > 3999 {
            return nil
        }
        return getRoman()
    }
    
    private func getRoman() -> String {
        return getRoman(number: self, order: 1000)
    }
    
    private func getRoman(number: Int, order: Int) -> String {
        if number == 0 {
            return ""
        }
        var vResult = ""
        if order == 1000 {
            var thousands = number / 1000
            let remainderThousands = number % 1000
            while thousands != 0 {
                vResult += intToRoman[order]!
                thousands -= 1
            }
            vResult += getRoman(number: remainderThousands, order: order / 10)
        } else {
            var num = number / order
            let remainderNum = number % order
            if num == 9 {
                vResult += intToRoman[num * order]!
            } else {
                if num / 5 != 0 {
                    vResult += intToRoman[5 * order]!
                    num = num % 5
                }
                if num == 4 { // сразу занулить или дальше else
                    vResult += intToRoman[num * order]!
                    num = 0
                }
                while num != 0 {
                    vResult += intToRoman[order]!
                    num -= 1
                }
            }
            vResult += getRoman(number: remainderNum, order: order / 10) // no need to use result
            
        }
        return vResult
    }
}
