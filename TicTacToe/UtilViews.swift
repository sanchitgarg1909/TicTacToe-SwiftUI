//
//  UtilViews.swift
//  TicTacToe
//
//  Created by Sanchit Garg on 14/09/21.
//

import SwiftUI

struct GameSquareView: View {
    
    var proxy: GeometryProxy
    var viewModel: GameViewModel
    var body: some View {
        Circle()
            .foregroundColor(.red).opacity(0.5)
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.width/3 - 15)
    }
}

struct PlayerIndicator: View {
    
    var systemImageName: String?
    var body: some View {
        if systemImageName != nil {
            Image(systemName: systemImageName!)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
        }
    }
}
