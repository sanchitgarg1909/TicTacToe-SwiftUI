//
//  GameView.swift
//  TicTacToe
//
//  Created by Sanchit Garg on 25/07/21.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    var centres = [CGPoint]()
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer().frame(height: 40)
                HStack {
                    Spacer().frame(width: 20)
                    VStack {
                        Text("Player").font(.title)
                        Text("\(viewModel.playerScore.clean)").font(.title2)
                    }
                    Spacer()
                    VStack {
                        Text("Computer").font(.title)
                        Text("\(viewModel.computerScore.clean)").font(.title2)
                    }
                    Spacer().frame(width: 20)
                }
                Spacer()
                
                LazyVGrid(columns: viewModel.columns, spacing: 5, content: {
                    ForEach(0..<9) { index in
                        ZStack {
                            GameSquareView(proxy: geometry, viewModel: viewModel)
                            
                            PlayerIndicator(systemImageName: viewModel.moves[index]?.indicator)
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: index)
                        }
                    }
                })

                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
            }
        }
    }
    
}

enum Player {
    case human,
         computer
}

struct Move {
    
    var player: Player
    var boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

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
