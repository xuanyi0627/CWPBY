//
//  ExDate.swift
//  CWPBY
//
//  Created by Xuanyi Liu on 2016/11/30.
//  Copyright © 2016年 Xuanyi Liu. All rights reserved.
//

import Foundation

extension Date {
    
    struct TimeFormatter {
        static let time = "HH:mm"
        static let date = "MM月dd日"
        static let week = "EEEE"
    }
    
    func currentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TimeFormatter.time
        return dateFormatter.string(from: self)
    }
    
    func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TimeFormatter.date
        return dateFormatter.string(from: self)
    }
    
    func currentWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TimeFormatter.week
        let week = dateFormatter.string(from: self)
        switch week {
        case "Monday": return "星期一"
        case "Tuesday": return "星期二"
        case "Wednesday": return "星期三"
        case "Thursday": return "星期四"
        case "Friday": return "星期五"
        case "Saturday": return "星期六"
        case "Sunday": return "星期日"
        default: return week
        }
    }
}
