//
//  DateHelper.swift
//  Picme
//
//  Created by 권민하 on 2021/09/04.
//

import Foundation

public class DateHelper {
    
    // 문자열 날짜를 Date 타입 날짜로 변환
    
    func stringToDate(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: dateString)
    }
    
    // 실제 지역 기반 시간으로 변환
    
    func getLocalDate(date: Date) -> Date? {
        // +9시간 해줘야지 한국 시간
        let calendar = Calendar.current
        let localDate = Date(timeInterval: TimeInterval(calendar.timeZone.secondsFromGMT()), since: date)
        return localDate
    }
    
    // 날짜를 현재시간 기준 초 시간으로 변환
    
    func getSeconds(date: Date) -> Int {
        return Int(Date().timeIntervalSince(date))
    }
    
    // 타이머에 나타낼 형식으로 반환
    
    func timerString(remainSeconds: Int) -> String {
        let hours   = Int(remainSeconds) / 3600
        let minutes = Int(remainSeconds) / 60 % 60
        let seconds = Int(remainSeconds) % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    // 마감시간 - 현재시간 = 타이머에 보여줄 시간 구하기
    
    func getTimer(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        
        let startLocalDate = Date(timeInterval: TimeInterval(calendar.timeZone.secondsFromGMT()), since: startDate)
        let endLocalDate = Date(timeInterval: TimeInterval(calendar.timeZone.secondsFromGMT()), since: endDate)
        
        let remainSeconds = Int(endLocalDate.timeIntervalSince(startLocalDate))
        
        // print("남은 시간? \(remainSeconds)")
        
        return remainSeconds
    }
    
}
