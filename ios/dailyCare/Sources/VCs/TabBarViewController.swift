//
//  TabBarViewController.swift
//  dailyCare
//

import UIKit
import Combine

class TabBarViewController: UITabBarController {
    
    let HEIGHT_TAB_BAR:CGFloat = 100
    
//    @Published var semail: String?    // 데이터를 전달받아 저장할 변수
    @Published var semail: [String] = []    // 데이터를 전달받아 저장할 변수
    private var cancellables: Set<AnyCancellable> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        let homeVC = MainViewController()
        let searchVC = PillSearchViewController()
        let CalVC = CalViewController()
        let MyPageVC = MyPageViewController()
        
        
        homeVC.tabBarItem.image = UIImage.init(systemName: "house")
        searchVC.tabBarItem.image = UIImage.init(systemName: "magnifyingglass")
        CalVC.tabBarItem.image = UIImage.init(systemName: "calendar")
        MyPageVC.tabBarItem.image = UIImage.init(systemName: "person.fill")
        
        //self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        
        // navigationController의 root view 설정
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationSearch = UINavigationController(rootViewController: searchVC)
        let navigationLibrary = UINavigationController(rootViewController: CalVC)
        let navigationMyPage = UINavigationController(rootViewController: MyPageVC)
    
        
        setViewControllers([navigationHome, navigationSearch, navigationLibrary, navigationMyPage], animated: false)
        $semail
            .sink { [weak self] newEmail in
                guard let self = self else { return }
                print("TabBar = semail changed to: \(newEmail ?? [])")
                // 여기에서 원하는 동작 수행
                MyPageVC.semail = newEmail
            }
            .store(in: &cancellables)
        
    }
    override func viewDidLayoutSubviews() {
                super.viewDidLayoutSubviews()
                var tabFrame = self.tabBar.frame
                tabFrame.size.height = HEIGHT_TAB_BAR
                tabFrame.origin.y = self.view.frame.size.height - HEIGHT_TAB_BAR
                self.tabBar.frame = tabFrame
            }
    
//    func setEmail(_ email: String) {
//        print("main email : ",email)
//        semail = email
//    }
    
}

