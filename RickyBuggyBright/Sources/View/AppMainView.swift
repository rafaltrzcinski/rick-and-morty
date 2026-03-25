//
//  AppMainView.swift
//  RickyBuggyBright
//

import SwiftUI

struct AppMainView: View {
    // FIXME: 13 - fix issue with re-invoking network request on tapping show list/hide list
    @ObservedObject var viewModel: AppMainViewModel = AppMainViewModel()
    @State private var showActionSheet = false
    
    var body: some View {
        NavigationView {
            characterListView
                .navigationTitle(Text("Characters"))
                .navigationBarTitleDisplayMode(.automatic)
                // FIXME: 7 - Fix issue with glitching toolbar on entering details view
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        sortButton
                    }
                }
        }
    }
}

// MARK: - View

private extension AppMainView {
    @ViewBuilder var characterListView: some View {
        if viewModel.characters.isEmpty == false {
            CharactersListView(characters: $viewModel.characters, sortMethod: $viewModel.sortMethod)
        } else if viewModel.characterErrors.isEmpty == false {
            FetchRetryView(errors: viewModel.characterErrors, onRetry: {
                viewModel.requestData()
            })
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }

    var sortButton: some View {
        Button("Choose Sorting") {
            showActionSheet = true
        }
        .actionSheet(isPresented: $showActionSheet) {
            sortActionSheet
        }
    }

    var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort method"),
            message: Text("Choose sorting method"),
            buttons: [
                .default(Text("Episodes Count")) {
                    viewModel.setSortMethod(.episodesCount)
                },
                .default(Text("Name")) {
                    viewModel.setSortMethod(.name)
                },
                .cancel(Text("Cancel")),
            ]
        )
    }
}

// MARK: - Preview

struct AppMainView_Previews: PreviewProvider {
    static var previews: some View {
        AppMainView()
    }
}
