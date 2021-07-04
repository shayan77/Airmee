//
//  Date+IsBetween.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/4/21.
//

import Foundation

extension Date {
    func isBetween(_ date1: Date?, and date2: Date?) -> Bool {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = -1
        let defaultDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        let castDate1 = date1 ?? defaultDate
        let castDate2 = date2 ?? defaultDate
        return (min(castDate1, castDate2) ... max(castDate1, castDate2)) ~= self
    }
    
    func convertDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMMM-dd"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
