//
//  MainView.swift
//  TicTacToe
//
//  Created by Sanchit Garg on 14/09/21.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack {
            if !viewModel.showStartScreen {
                GameView(viewModel: viewModel)
            } else {
                StartView(viewModel: viewModel)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
