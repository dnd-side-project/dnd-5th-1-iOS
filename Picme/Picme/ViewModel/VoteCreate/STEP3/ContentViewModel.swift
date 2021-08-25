//
//  ContentViewModel.swift
//  Picme
//
//  Created by taeuk on 2021/08/15.
//

import Foundation

enum ExpirationDate: String, CaseIterable {
    
    case timeSelect = "시간 선택"
    case half   = "30 분"
    case one    = "1 시간"
    case two    = "2 시간"
    case three  = "3 시간"
    case six    = "6 시간"
    case twelve = "12 시간"
    case day    = "24 시간"
    
    var timeValue: Int {
        switch self {
        case .timeSelect: return 0
        case .half:     return 30
        case .one:      return 1
        case .two:      return 2
        case .three:    return 3
        case .six:      return 6
        case .twelve:   return 12
        case .day:      return 24
        }
    }
}

class ContentViewModel {
    
    static var imagesData: CreateCase = .userImage(date: [])
    static var imageMetaData: CreateCase = .userImageMetadata(data: CreateUserImages(isFirstPick: 0,
                                                                                     sizes: []))
    
    var hasTitleText: Dynamic<Bool> = Dynamic(false)
    var hasVoteEndDate: Dynamic<Bool> = Dynamic(false)
    var isCompleteState: Dynamic<Bool> = Dynamic(false)
    
    // 투표 통신완료시 홈화면으로 이동
    var isCreateListComplete: Dynamic<Bool> = Dynamic(false)
    var isCreateImageComplete: Dynamic<Bool> = Dynamic(false)
    var isCreateComplete: Dynamic<Bool> = Dynamic(false)
    
    func completeCheck() {
        if hasTitleText.value == true && hasVoteEndDate.value == true {
            isCompleteState.value = true
        } else {
            isCompleteState.value = false
        }
    }
    
    // 마감 시간
    func stringConvertDate(_ hour: ExpirationDate) -> String? {
    
        switch hour {
        case .timeSelect, .half, .one, .two, .three, .six, .twelve, .day:
            return addDate(hour.timeValue)
        }
    }
    
    func addDate(_ value: Int) -> String {
        let date = Date()
        
        let dateForMatter = DateFormatter()
        dateForMatter.dateFormat = "yy/MM/dd HH:mm"
        
        var addingDate: Date?
        
        switch value {
        case 30:
            addingDate = Calendar.current.date(byAdding: .minute, value: value, to: date)
        default:
            addingDate = Calendar.current.date(byAdding: .hour, value: value, to: date)
        }
    
        guard let addingDate = addingDate else { return "Null"}
        return dateForMatter.string(from: addingDate)
    }
    
    func createList(title: String, endDate: String, completion: @escaping () -> Void) {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yy/MM/dd HH:mm"
        
        let convertDateformatter = DateFormatter()
        convertDateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let stringConvertDate = dateformatter.date(from: endDate) {
            
            let postDate = convertDateformatter.string(from: stringConvertDate)
            print(postDate)
            let createList = CreateCase.listConfigure(title: title, endDate: postDate)
            
            CreateVoteService.fetchCreateList(createList) { [weak self] response in
                switch response {
                case .success(let data):
                    
                    print("=====================")
                    print("POST ID:", data.postId)
                    print("=====================")
                    
                    CreateVoteService.fetchCreateImage(postID: data.postId,
                                                       ContentViewModel.imagesData,
                                                       ContentViewModel.imageMetaData) { [weak self] in
                        self?.isCreateImageComplete.value = true
                        completion()
                    }
                    
                case .failure(let err):
                    print(err.localized)
                }
            }
        }
    }
}

enum CreateCase {
    case userImage(date: [Data])
    case userImageMetadata(data: CreateUserImages)
    case listConfigure(title: String, endDate: String)
}
