import UIKit

private enum Layout {
    static let padding: CGFloat = 12
    static let spacing: CGFloat = 12
    static let columnCount: Int = 2
}

final class PopularMoviesViewController: UIViewController {
    private var nextPage: Int = 1
    private var totalPages: Int = 1
    private var movies: [PopularMovie] = []

    private var isLoading = false
    private var fetchTask: Task<Void, Never>?

    private var dataSource: DataSource?

    private lazy var collectionView: UICollectionView = {
        let padding = Layout.padding
        let spacing = Layout.spacing
        let columnCount = Layout.columnCount

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        let sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.sectionInset = sectionInset

        let totalHorizontalSpacing = sectionInset.left + sectionInset.right + spacing * CGFloat(columnCount - 1)
        let itemWidth = (view.frame.width - totalHorizontalSpacing) / CGFloat(columnCount)
        let itemHeight = PopularMovieCell.cellHeight(for: itemWidth)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(PopularMovieCell.self, forCellWithReuseIdentifier: PopularMovieCell.identifier)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()

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
        configureViewController()
        setupUI()
        configureDataSource()
        fetchData()
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupUI() {
        view.addSubview(collectionView)
    }

    private func fetchData() {
        guard nextPage <= totalPages, !isLoading else { return }

        isLoading = true
        fetchTask?.cancel()

        fetchTask = Task { [weak self] in
            guard let self else { return }
            defer { isLoading = false }

            do {
                let response = try await TMDbService.shared.fetchPopularMovies(page: nextPage)

                try Task.checkCancellation()

                nextPage = response.page + 1
                totalPages = response.totalPages

                let newMovies = response.results
                let existingIds = Set(movies.map(\.id))
                let uniqueNewMovies = newMovies.filter { !existingIds.contains($0.id) }

                movies.append(contentsOf: uniqueNewMovies)
                updateSnapshot()
            } catch is CancellationError { // ignore
            } catch {
                presentErrorAlert(for: error)
            }
        }
    }
}

extension PopularMoviesViewController {
    enum Section { case main }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, PopularMovie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PopularMovie>

    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, movie in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PopularMovieCell.identifier,
                for: indexPath
            ) as? PopularMovieCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: movie)
            return cell
        })
    }

    @MainActor private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension PopularMoviesViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
        let hasMorePages = nextPage <= totalPages
        guard hasMorePages, !isLoading else { return }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            fetchData()
        }
    }
}
