//
//  Protocol+LoginState.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/13.
//

import Foundation

protocol LoginState: AnyObject {
    
    func loginSuccess()
    func loginFail(error: String)
}
