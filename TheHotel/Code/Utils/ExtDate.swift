//
//  ExtDate.swift
//  TheHotel
//
//  Created by Jaime Tejeiro on 9/9/24.
//

import Foundation

extension Date {
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "es_ES")
        return dateFormatter.string(from: self)
    }
}
