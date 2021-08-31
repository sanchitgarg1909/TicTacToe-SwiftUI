//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Sanchit Garg on 25/07/21.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]

    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    @Published var playerScore: CGFloat = 0
    @Published var computerScore: CGFloat = 0
        
    func processPlayerMove(for position: Int) {
        guard !isSquareOccupied(in: moves, at: position) else { return }
        let move = Move(player: .human, boardIndex: position)
        moves[position] = move
        isGameBoardDisabled = true

        if checkWinCondition(for: .human, in: moves) {
            playerScore += 1
            alertItem = AlertContext.humanWin
        } else if checkForDraw(in: moves) {
            playerScore += 0.5
            computerScore += 0.5
            alertItem = AlertContext.draw
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                let computerPosition = makeComputerMove(in: moves)
                let move = Move(player: .computer, boardIndex: computerPosition)
                moves[computerPosition] = move

                if checkWinCondition(for: .computer, in: moves) {
                    computerScore += 1
                    alertItem = AlertContext.computerWin
                } else {
                    isGameBoardDisabled = false
                }

            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], at index: Int) -> Bool {
        return moves[index] != nil
    }
    
    // If AI can win, then win
    // If AI can't win, then stop player from winning
    // If player is not winning, take the middle square
    // If middle square is taken, choose randomly
    func makeComputerMove(in moves: [Move?]) -> Int {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

        // If AI can win, then win
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })

        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                if !isSquareOccupied(in: moves, at: winPositions.first!) {
                    return winPositions.first!
                }
            }
        }

        // If AI can't win, then stop player from winning
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })

        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1 {
                if !isSquareOccupied(in: moves, at: winPositions.first!) {
                    return winPositions.first!
                }
            }
        }

        // If player is not winning, take the middle square
        let centreSquare = 4
        if !isSquareOccupied(in: moves, at: centreSquare) {
            return centreSquare
        }

        // If middle square is taken, choose randomly
        var movePosition = Int.random(in: 0..<9)

        while isSquareOccupied(in: moves, at: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }

        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })

        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isGameBoardDisabled = false
    }
    
}

extension CGFloat {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
