import UIKit

final class MTTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = Tab.allCases.map(\.controller)
    }
}

extension MTTabBarController {
    enum Tab: Int, CaseIterable {
        case popular
        case myList

        var icon: UIImage? {
            switch self {
            case .popular: UIImage(systemName: SFSymbols.flameFill)
            case .myList: UIImage(systemName: SFSymbols.listDash)
            }
        }

        var rootViewControllerType: UIViewController.Type {
            switch self {
            case .popular: MTPopularMoviesViewController.self
            case .myList: MTMyListViewController.self
            }
        }

        var controller: UINavigationController {
            let root = rootViewControllerType.init()
            root.tabBarItem = UITabBarItem(title: root.title, image: icon, tag: rawValue)
            return UINavigationController(rootViewController: root)
        }
    }
}
