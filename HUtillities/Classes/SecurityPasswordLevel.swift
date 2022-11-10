// SecurityPasswordLevel.swift 
// HUtillities 
//
// Created by Khouv Tannhuot on 10/11/22. 
// Copyright (c) 2022 Khouv Tannhuot. All rights reserved. 
//

import Foundation

public enum SecurityPasswordStrengthLevelEnum {
    // Plain text or numeric
    case weak
    // Plain text plus numeric
    case fair
    // Plain text plus numeric plus campital letter
    case medium
    // Plain text plus numeric plus campital letter plus symbol character
    case strong
    // Plain text plus numeric plus campital letter plus symbol character ( more than two symbols) and 9 characters up
    case veryStrong
    
    case tooShort
}

open class SecurityPasswordLevel {
    public static func strength(ofPassword password: String) -> SecurityPasswordStrengthLevelEnum {
        return passwordStrength(forEntropy: entropy(of: password))
    }
    
    private static func entropy(of string: String) -> Float {
        guard string.count > 0 else {
            return 0
        }
        
        var includesLowercaseCharacter = false,
        includesUppercaseCharacter = false,
        includesDecimalDigitCharacter = false,
        includesSpcialCharacter = false,
        includesSecondSpecialCharacter = false
        var firstSpecialCharacter = 0
        var sizeOfCharacterSet: Float = 0
        
        string.enumerateSubstrings(in: string.startIndex ..< string.endIndex, options: .byComposedCharacterSequences) { subString, r, _, _ in
            guard let unicodeScalars = subString?.first?.unicodeScalars.first else {
                return
            }
            // Include lowercase letter
            if !includesLowercaseCharacter && CharacterSet.lowercaseLetters.contains(unicodeScalars) {
                includesLowercaseCharacter = true
                sizeOfCharacterSet += 1
            }
            // Include uppercase letter
            if !includesUppercaseCharacter && CharacterSet.uppercaseLetters.contains(unicodeScalars) {
                includesUppercaseCharacter = true
                sizeOfCharacterSet += 1
            }
            // Include decimal digit
            if !includesDecimalDigitCharacter && CharacterSet.decimalDigits.contains(unicodeScalars) {
                includesDecimalDigitCharacter = true
                sizeOfCharacterSet += 1
            }
            // Include symbol
            if !includesSpcialCharacter && CharacterSet.symbols.contains(unicodeScalars) {
                includesSpcialCharacter = true
                sizeOfCharacterSet += 1
            }
            // Include punctuatin
            if !includesSpcialCharacter && CharacterSet.punctuationCharacters.contains(unicodeScalars) {
                firstSpecialCharacter = r.hashValue
                includesSpcialCharacter = true
                sizeOfCharacterSet += 1
            }
            
            if !includesSecondSpecialCharacter && includesSpcialCharacter && CharacterSet.punctuationCharacters.contains(unicodeScalars) && r.hashValue != firstSpecialCharacter && string.count > 8 {
                includesSecondSpecialCharacter = true
                sizeOfCharacterSet += 1
            }
        }
        return  sizeOfCharacterSet
    }
    
    private static func passwordStrength(forEntropy entropy: Float) -> SecurityPasswordStrengthLevelEnum {
        switch entropy {
        case 1: return .weak
        case 2: return .fair
        case 3: return .medium
        case 4: return .strong
        case 5: return .veryStrong
        default:
            return .tooShort
        }
    }
}
