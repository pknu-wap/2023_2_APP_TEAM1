
import UIKit

class TabBarViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        let homeVC = MainViewController()
        let searchVC = PillSearchViewController()
        let CalVC = CalViewController()
        
        //각 tab bar의 viewcontroller 타이틀 설정
        
        homeVC.title = "Home"
        searchVC.title = "Search"
        CalVC.title = "Calender"
        
        homeVC.tabBarItem.image = UIImage.init(systemName: "house")
        searchVC.tabBarItem.image = UIImage.init(systemName: "magnifyingglass")
        CalVC.tabBarItem.image = UIImage.init(systemName: "calendar")
        
        //self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        
        // 위에 타이틀 text를 항상 크게 보이게 설정
        homeVC.navigationItem.largeTitleDisplayMode = .always
        searchVC.navigationItem.largeTitleDisplayMode = .always
        CalVC.navigationItem.largeTitleDisplayMode = .always
        
        // navigationController의 root view 설정
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationSearch = UINavigationController(rootViewController: searchVC)
        let navigationLibrary = UINavigationController(rootViewController: CalVC)
        
    
        navigationHome.navigationBar.prefersLargeTitles = true
        navigationSearch.navigationBar.prefersLargeTitles = true
        navigationLibrary.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navigationHome, navigationSearch, navigationLibrary], animated: false)
        
    }
    
    func setEmail(_ email: String) {
        print("main email : ",email)
    }
    
}
