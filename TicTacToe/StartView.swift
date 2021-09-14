//
//  StartView.swift
//  TicTacToe
//
//  Created by Sanchit Garg on 08/09/21.
//

import SwiftUI

struct StartView: View {
    
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack {
            if !viewModel.showStartScreen {
                GameView(viewModel: viewModel)
            } else {
                
                Button("Play as X") {
                    viewModel.setHumanAsX()
                    viewModel.showStartScreen = false
                    viewModel.checkFirstMove()
                }
                .font(.title2)
                .frame(width: 150, height: 50)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Spacer().frame(height: 50)
                
                Text("OR").font(.title)
                
                Spacer().frame(height: 50)
                
                Button("Play as O") {
                    viewModel.setHumanAsO()
                    viewModel.showStartScreen = false
                    viewModel.checkFirstMove()
                }
                .font(.title2)
                .frame(width: 150, height: 50)
                .padding()
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
