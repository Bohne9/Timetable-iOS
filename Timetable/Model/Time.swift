//
//  Time.swift
//  Timetable
//
//  Created by Jonah Schueller on 07.03.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import Foundation

struct Time: CustomStringConvertible{
    
    var description: String{
        get{
           return getDescriptionFor(Language.shared.language)
        }
    }
    
    private func getDescriptionFor(_ country: LanguageType) -> String{
        if country == .German {
            var str: String = hours < 10 ? "0\(hours):" : "\(hours):"
            str += minutes < 10 ? "0\(minutes)" : "\(minutes)"
            
            return str
        }else {
            var str: String = "\(hours == 12 || hours == 24 ? 12 : hours % 12):"
            str += minutes < 10 ? "0\(minutes)" : "\(minutes)"
            str += " \(hours <= 12 ? "am" : "pm")"
            
            return str
        }
    }
    
    var value: Double{
        get {
            return Double(hours) + (Double(minutes) / 60.0)
        }
    }
    
    var database: String {
        get{
            return getDescriptionFor(.German)
        }
    }
    
    var hours: Int = 0
    var minutes: Int = 0
    
    init(_ h: Int, _ m: Int) {
        hours = h
        minutes = m
    }
    
    init(_ s: String) {
        var matched = false
        do {
            // AM-PM
            let regex = try NSRegularExpression(pattern: "((0*[0-9])|(1[0-2])):((0?[0-9])|([1-5][0-9])) *((am)|(pm))", options: .caseInsensitive)
            let results = regex.matches(in: s, range: NSRange(s.startIndex..., in: s))
            
            if results.count != 0 {
                matched = true
                let result = s[Range(results.first!.range, in: s)!]
                
                let addition = (result.lowercased().range(of: "am") != nil) ? 0 : 12
                
                let split = result.split(separator: ":")
                hours = Int(split[0])! + addition
                let s1 = String(split[1])
                minutes = Int(s1.prefix(upTo: s1.index(s1.startIndex, offsetBy: 2)))!
                
            }
            
            
        }catch {
            
        }
        if !matched {
            let split = s.split(separator: ":")
            hours = Int(split[0])!
        
            minutes = Int(split[1])!
        }
    }
}
