import Foundation

import Combine

class SharedData {
    static let shared = SharedData()

    @Published var userInfo: [String] = []
    
    private var cancellables: Set<AnyCancellable> = []

    private init() {}

}
