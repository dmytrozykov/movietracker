import UIKit

final class MTMoviesViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("movies_screen_title", comment: "Movies screen title")
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}
