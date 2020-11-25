
class FilesExplorerContainerViewController: UIViewController {
    //MARK:- Private variables

    private let viewModel: FilesExplorerViewModel
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.hidesNavigationBarDuringPresentation = false
        return sc
    }()
    
    //MARK:- States

    lazy var currentState = states[FilesExplorerContainerListViewState.identifier]!
    lazy var states = [
        FilesExplorerContainerListViewState.identifier:
            FilesExplorerContainerListViewState(containerViewController: self,
                                                viewModel: viewModel),
        FilesExplorerContainerGridViewState.identifier:
            FilesExplorerContainerGridViewState(containerViewController: self,
                                                viewModel: viewModel)
    ]
    
    //MARK:-
    
    init(viewModel: FilesExplorerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        if UserDefaults.standard.integer(forKey: MEGAExplorerViewModePreference) == ViewModePreference.thumbnail.rawValue {
            currentState = states[FilesExplorerContainerGridViewState.identifier]!
        } else {
            currentState = states[FilesExplorerContainerListViewState.identifier]!
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentState.showContent()
        showMoreRightBarButton()
        configureSearchBar()
    }
    
    // Problem: When the view is displayed on the screen the search bar isn't visible but the expectation is to show it.
    // Solution: This solution is picked up from stackoverflow in the link https://stackoverflow.com/a/46352230/397915
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    //MARK:- Bar Buttons    
    func updateTitle(_ title: String?) {
        self.title = title
    }
    
    func showCancelRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: AMLocalizedString("cancel"),
            style: .plain,
            target: self,
            action: #selector(cancelButtonPressed(_:)))
    }
    
    func showSelectAllBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "selectAll"),
            style: .plain,
            target: self,
            action: #selector(selectAllButtonPressed(_:))
        )
    }
    
    func hideKeyboardIfRequired() {
        if searchController.isActive {
            searchController.searchBar.resignFirstResponder()
        }
    }
    
    func updateSearchResults() {
        updateSearchResults(for: searchController)
    }
    
    func configureNavigationBarToDefault() {
        showMoreRightBarButton()
        navigationItem.leftBarButtonItem = nil
        updateTitle(currentState.title)
    }
    
    func setViewModePreference(_ preference: ViewModePreference) {
        assert(preference != .perFolder, "Preference cannot be per folder")
        UserDefaults.standard.setValue(preference.rawValue, forKey: MEGAExplorerViewModePreference)
    }
    
    private func showMoreRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "moreSelected"),
            style: .plain,
            target: self, action: #selector(moreButtonItemSelected(_:))
        )
    }
    
    //MARK:- Actions

    @objc private func moreButtonItemSelected(_ button: UIBarButtonItem) {
        currentState.showPreferences(sender: button)
    }
    
    @objc private func cancelButtonPressed(_ button: UIBarButtonItem) {
        currentState.endEditingMode()
    }
    
    @objc private func selectAllButtonPressed(_ button: UIBarButtonItem) {
        currentState.selectAllNodes()
    }
    
    func configureSearchBar() {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            currentState.configureSearchController(searchController)
        }
    }
    
    //MARK:- Action sheet methods
    
    func showPreferences(withViewPreferenceAction viewPreferenceAction: ActionSheetAction, sender: UIBarButtonItem) {
        let sortPreferenceAction = ActionSheetAction(
            title: AMLocalizedString("sortTitle", "Section title of the 'Sort by'"),
            detail: NSString.localizedSortOrderType(Helper.sortType(for: nil)),
            image: UIImage(named: "sort"), style: .default) { [weak self] in
            self?.showSortOptions(sender: sender)
        }
        
        let selectAction = ActionSheetAction(
            title: AMLocalizedString("select", "Button that allows you to select a given folder") ,
            detail: nil,
            image: UIImage(named: "select"),
            style: .default) { [weak self] in
            self?.showCancelRightBarButton()
            self?.showSelectAllBarButton()
            self?.currentState.setEditingMode()
        }
        
        let actionSheetVC = ActionSheetViewController(
            actions: [viewPreferenceAction, sortPreferenceAction, selectAction],
            headerTitle: nil,
            dismissCompletion: nil,
            sender: sender
        )

        present(actionSheetVC, animated: true)
    }
    
    func showSortOptions(sender: UIBarButtonItem) {
        let checkmarkImageView = UIImageView(image: UIImage(named: "turquoise_checkmark"))
                
        let actions = SortOrderType.allValid.map { sortOrderType in
            ActionSheetAction(title: sortOrderType.localizedString,
                              detail: nil,
                              accessoryView: SortOrderType.defaultSortOrderType(forNode: nil) == sortOrderType ? checkmarkImageView : nil,
                              image: sortOrderType.image,
                              style: .default) { [weak self] in
                Helper.save(sortOrderType.megaSortOrderType, for: nil)
                
                guard let self = self else { return }
                self.updateSearchResults(for: self.searchController)
            }
        }
        
        let actionSheetVC = ActionSheetViewController(
            actions: actions,
            headerTitle: nil,
            dismissCompletion: nil,
            sender: sender
        )
        
        present(actionSheetVC, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension FilesExplorerContainerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.trim else {
            currentState.updateSearchResults(for: nil)
            return
        }
        
        currentState.updateSearchResults(for: searchText)
    }
}

// MARK: - UISearchControllerDelegate
extension FilesExplorerContainerViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        currentState.updateSearchResults(for: nil)
    }
}

extension FilesExplorerContainerViewController: TraitEnviromentAware {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollectionChanged(to: traitCollection, from: previousTraitCollection)
    }
    
    func colorAppearanceDidChange(to currentTrait: UITraitCollection, from previousTrait: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            AppearanceManager.forceSearchBarUpdate(searchController.searchBar,
                                                   traitCollection: traitCollection)
        }
    }
}