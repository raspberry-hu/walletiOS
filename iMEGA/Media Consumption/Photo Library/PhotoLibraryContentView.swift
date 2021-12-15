import SwiftUI

@available(iOS 14.0, *)
struct PhotoLibraryContentView: View {
    @ObservedObject var viewModel: PhotoLibraryContentViewModel
    var router: PhotoLibraryContentViewRouting
    
    init(viewModel: PhotoLibraryContentViewModel, router: PhotoLibraryContentViewRouting) {
        self.viewModel = viewModel
        self.router = router
        configSegmentedControlAppearance()
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            photoContent()
                .safeAreaInset(edge: .bottom) {
                    pickerFooter()
                }
        } else {
            ZStack(alignment: .bottom) {
                photoContent()
                pickerFooter()
            }
        }
    }
    
    private func pickerFooter() -> some View {
        viewModePicker()
            .blurryBackground(radius: 7)
            .padding(16)
    }
    
    private func viewModePicker() -> some View {
        Picker("View Mode", selection: $viewModel.selectedMode) {
            ForEach(PhotoLibraryViewMode.allCases) {
                Text($0.title)
                    .font(.headline)
                    .bold()
                    .tag($0)
            }
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder
    private func photoContent() -> some View {
        if viewModel.library.isEmpty {
            EmptyView()
        } else {
            switch viewModel.selectedMode {
            case .year:
                let vm = PhotoLibraryYearViewModel(libraryViewModel: viewModel,
                                                   photoCategoryList: viewModel.library.photosByYearList)
                PhotoLibraryYearView(viewModel: vm, router: router)
            case .month:
                let vm = PhotoLibraryMonthViewModel(libraryViewModel: viewModel,
                                                    photoCategoryList: viewModel.library.allPhotosByMonthList)
                PhotoLibraryMonthView(viewModel: vm, router: router)
            case .day:
                let vm = PhotoLibraryDayViewModel(libraryViewModel: viewModel,
                                                  photoCategoryList: viewModel.library.allPhotosByDayList)
                PhotoLibraryDayView(viewModel: vm, router: router)
            case .all:
                let vm = PhotoLibraryAllViewModel(libraryViewModel: viewModel,
                                                  photoCategoryList: viewModel.library.allPhotosMonthSections)
                PhotoLibraryAllView(viewModel: vm, router: router, calculator: ScrollPositionCalculator())
            }
        }
    }
    
    private func configSegmentedControlAppearance() {
        UISegmentedControl
            .appearance()
            .setTitleTextAttributes(
                [.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                 .foregroundColor: UIColor.systemBackground],
                for: .selected
            )
        
        UISegmentedControl
            .appearance()
            .setTitleTextAttributes(
                [.font: UIFont.systemFont(ofSize: 13, weight: .medium),
                 .foregroundColor: UIColor.label],
                for: .normal
            )
        
        UISegmentedControl
            .appearance()
            .selectedSegmentTintColor = UIColor.label.withAlphaComponent(0.4)
    }
}