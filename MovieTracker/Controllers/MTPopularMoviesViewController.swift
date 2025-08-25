import UIKit

final class MTPopularMoviesViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("popular_movies_screen_title", comment: "Popular movies screen title")
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        fetchData()
    }

    private func fetchData() {
        Task {
            do {
                let response = try await TMDbService.shared.fetchPopularMovies()
                print(response.results)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
