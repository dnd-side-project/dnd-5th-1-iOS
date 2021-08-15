//
//  ContentViewModel.swift
//  Picme
//
//  Created by taeuk on 2021/08/15.
//

import Foundation

enum ExpirationDate: String, CaseIterable {
    case zero   = "0 시간"
    case one    = "1 시간"
    case two    = "2 시간"
    case three  = "3 시간"
    case six    = "6 시간"
    case twelve = "12 시간"
}

class ContentViewModel {
    
    var hasTitleText: Dynamic<Bool> = Dynamic(false)
    var hasVoteEndDate: Dynamic<Bool> = Dynamic(false)
    var isCompleteState: Dynamic<Bool> = Dynamic(false)
    
    func completeCheck() {
        if hasTitleText.value == true && hasVoteEndDate.value == true {
            isCompleteState.value = true
        } else {
            isCompleteState.value = false
        }
    }
    
    func stringConvertDate(_ hour: ExpirationDate) -> String? {
        
        switch hour {
        case .zero:
            return addDate(0)
        case .one:
            return addDate(1)
        case .two:
            return addDate(2)
        case .three:
            return addDate(3)
        case .six:
            return addDate(6)
        case .twelve:
            return addDate(12)
        }
    }
    
    func addDate(_ value: Int) -> String {
        let date = Date()
        
        guard let addingDate = Calendar.current.date(byAdding: .hour, value: value, to: date) else { return "NULL"
        }
        
        let dateForMatter = DateFormatter()
        dateForMatter.dateFormat = "yy/MM/dd HH:mm"
        
        return dateForMatter.string(from: addingDate)
    }
}
