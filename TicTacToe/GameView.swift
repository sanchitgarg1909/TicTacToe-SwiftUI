//
//  GameView.swift
//  TicTacToe
//
//  Created by Sanchit Garg on 25/07/21.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var viewModel: GameViewModel
    
    var centres = [CGPoint]()
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                                
                                PlayerIndicator(systemImageName: viewModel.board[index]?.rawValue)
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
                
                if viewModel.isGameBoardDisabled {
                    ProgressView("Computer thinking...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.4)
                        .frame(width: 260, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(RoundedRectangle(cornerRadius: 40)
                                        .fill(Color(UIColor.lightGray)))
                }
                
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = GameViewModel()
        GameView(viewModel: viewModel)
    }
}
