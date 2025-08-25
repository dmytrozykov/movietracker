import UIKit

final class MTTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = Tab.allCases.map(\.controller)
    }
}

extension MTTabBarController {
    enum Tab: Int, CaseIterable {
        case movies
        case myList

        var icon: UIImage? {
            switch self {
            case .movies: UIImage(systemName: SFSymbols.movieclapper)
            case .myList: UIImage(systemName: SFSymbols.listDash)
            }
        }

        var rootViewControllerType: UIViewController.Type {
            switch self {
            case .movies: MTMoviesViewController.self
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
