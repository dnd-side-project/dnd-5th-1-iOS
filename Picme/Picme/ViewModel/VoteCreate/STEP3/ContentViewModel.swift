//
//  ContentViewModel.swift
//  Picme
//
//  Created by taeuk on 2021/08/15.
//

import Foundation

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
}
