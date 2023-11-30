//
//  userInfo.swift
//  dailyCare
//
// 유저의 주의사항 정보를 위한 데이터

import Foundation

import Combine

class SharedData {
    static let shared = SharedData()

    @Published var userInfo: [[String]] = []
    
    private var cancellables: Set<AnyCancellable> = []

    private init() {
        print(userInfo)
    }

}
