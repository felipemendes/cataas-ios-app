//
//  HomeView.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var coordinator: HomeCoordinator
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var hasLoaded: Bool = false
    @State private var contentOpacity: Double = 0.0

    private let animateDuration: CGFloat = 0.3
    private let iPhonePortraitColumns: Int = 2
    private let iPhoneLandscapeColumns: Int = 4
    private let iPadColumns: Int = 4
    private let gridSpacing: CGFloat = 20

    var body: some View {
        NavigationView {
            ScrollViewReader { scrollViewProxy in
                if let errorMessage = viewModel.errorMessage, viewModel.cats.isEmpty {
                    ErrorView(message: errorMessage, onRetry: {
                        viewModel.fetchCats()
                    })
                } else if viewModel.isLoading && viewModel.cats.isEmpty {
                    ProgressView()
                        .controlSize(.large)
                } else {
                    ZStack(alignment: .bottom){
                        contentView
                            .opacity(contentOpacity)
                            .onAppear {
                                withAnimation(.easeIn(duration: animateDuration)) {
                                    contentOpacity = 1.0
                                }
                            }

                        if viewModel.hasMoreData {
                            loadMoreButton(scrollViewProxy)
                        }
                    }
                }
            }
            .navigationBarTitle("Cats")
        }
        .onAppear {
            if !hasLoaded {
                viewModel.fetchCats()
                hasLoaded = true
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension HomeView {
    private var contentView: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns(for: geometry.size.width), spacing: gridSpacing) {
                    catCards
                }
                .padding()
            }
        }
    }

    private var catCards: some View {
        ForEach(viewModel.cats) { cat in
            Button(action: { [weak coordinator] in
                coordinator?.showDetail(with: cat)
            }) {
                CatCardView(cat: cat)
                    .transition(.opacity)
            }
            .buttonStyle(PlainButtonStyle())
            .background(
                NavigationLink(
                    destination: coordinator.makeDetailView(),
                    tag: cat,
                    selection: $coordinator.selectedCat, label: {
                        EmptyView()
                    }
                )
            )
        }
    }

    private func loadMoreButton(_ scrollViewProxy: ScrollViewProxy) -> some View {
        Button(action: {
            viewModel.fetchCats()

            if let lastCat = viewModel.cats.last {
                withAnimation {
                    scrollViewProxy.scrollTo(lastCat.id, anchor: .bottom)
                }
            }
        }) {
            LoadMoreButton()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical)
    }
}

extension HomeView {
    private func columns(for width: CGFloat) -> [GridItem] {
        let columnCount: Int
        if UIDevice.current.userInterfaceIdiom == .phone && width > UIScreen.main.bounds.height {
            columnCount = iPhoneLandscapeColumns
        } else {
            columnCount = horizontalSizeClass == .compact ? iPhonePortraitColumns : iPadColumns
        }
        return Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: columnCount)
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(
            catService: CatService(),
            appLogger: AppLogger(
                subsystem: "preview",
                category: "preview")
        )
    )
    .environmentObject(HomeCoordinator())
}
