//
//  String+Extension.swift
//  GG-Games
//
//  Created by Morshed Alam on 4/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)

import UIKit

#elseif os(OSX)

import Cocoa

#endif

extension String {
    
    // Trim
    var trim: String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
    }
    
    // Remove extra white spaces
    var extendedTrim: String {
        
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ").trim
        
    }
    
    //    // Decode HTML entities
    //    var decoded: String {
    //
    //        let encodedData = self.data(using: String.Encoding.utf8)!
    //        let attributedOptions: [String: AnyObject] =
    //            [
    //                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
    //                NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue as AnyObject
    //        ]
    //
    //        do {
    //
    //            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
    //
    //            return attributedString.string
    //
    //        } catch _ {
    //
    //            return self
    //
    //        }
    //
    //    }
    
    
    // Delete tab by pattern
    func deleteTagByPattern(_ pattern: String) -> String {
        
        return self.replacingOccurrences(of: pattern, with: "", options: .regularExpression, range: nil)
        
    }
    
    // Replace
    func replace(_ search: String, with: String) -> String {
        
        let replaced: String = self.replacingOccurrences(of: search, with: with)
        
        return replaced.isEmpty ? self : replaced
        
    }
    
    // Substring
    func substring(_ start: Int, end: Int) -> String {
        
        return String(self[Range(self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: end))])
        
        //        return self.substring(with: Range(self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: end)))
        
    }
    func substring(_ range: NSRange) -> String {
        
        var end = range.location + range.length
        end = end > self.count ? self.count - 1 : end
        
        return self.substring(range.location, end: end)
        
    }
    
    
    
}
