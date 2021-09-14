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

    @Published var board: Board = []

    @Published var isGameBoardDisabled = true
    @Published var alertItem: AlertItem?
    
    @Published var playerScore: CGFloat = 0
    @Published var computerScore: CGFloat = 0
    
    @Published var showStartScreen = true
    
    var humanPlayer: Player = .X
    var computerPlayer: Player = .O
    
    init() {
        board = initialState()
    }
    
    // Returns player who has the next turn on a board.
    func initialState() -> Board {
        return  [EMPTY, EMPTY, EMPTY,
                EMPTY, EMPTY, EMPTY,
                EMPTY, EMPTY, EMPTY]
    }
    
    // Returns player who has the next turn on a board.
    func player(board: Board) -> Player {
        
        let remainingMoves = board.filter({ $0 == EMPTY }).count
        
        if remainingMoves % 2 != 0 {
            return .X
        } else {
            return .O
        }
    }
    
    // Returns set of moves of a player, if player is nil returns all possible moves
    func moves(board: Board, player: Player? = EMPTY) -> [Move] {
        var moves = [Move]()
        for (pos , value) in board.enumerated() {
            if value == player {
                moves.append(pos)
            }
        }
        
        return moves
    }
    
    // Returns the board that results from making move (i, j) on the board.
    func result(board: Board, move: Move) -> Board {
        
        if board[move] != EMPTY {
            return board
        }
        
        let nextMove = player(board: board)

        var newBoard = board
        newBoard[move] = nextMove
        
        return newBoard
    }
    
    // Returns the winner of the game, if there is one.
    func winner(board: Board) -> Player? {
        
        let movesOfX = moves(board: board, player: .X)
        if checkWinPattern(moves: movesOfX) {
            return .X
        }

        let movesOfO = moves(board: board, player: .O)
        if checkWinPattern(moves: movesOfO) {
            return .O
        }
        
        return nil
    }
    
    // Returns the winner of the game, if there is one.
    func checkWinPattern(moves: [Move]) -> Bool {
        
        let winPatterns: Set<Set<Int>> = [[0, 1, 2],
                                          [3, 4, 5],
                                          [6, 7, 8],
                                          [0, 3, 6],
                                          [1, 4, 7],
                                          [2, 5, 8],
                                          [0, 4, 8],
                                          [2, 4, 6]]

        for pattern in winPatterns where pattern.isSubset(of: moves) {
            return true
        }

        return false
    }

    // Returns True if game is over, False otherwise.
    func terminal(board: Board) -> Bool {
        
        if winner(board: board) != nil {
            return true
        }
        
        return board.filter({ $0 == EMPTY }).isEmpty
    }
    
    // Returns 1 if X has won the game, -1 if O has won, 0 otherwise.
    func utility(board: Board) -> Int {

        let winner = winner(board: board)
        if winner == .X {
            return X_WINS
        } else if winner == .O {
            return O_WINS
        } else {
            return DRAW
        }
    }
    
    // Returns the optimal action for the current player on the board.
    func minimax(board: Board) -> Move? {

        if terminal(board: board) {
            return nil
        }

        let nextMove = player(board: board)
        
        if nextMove == .X {
            let (_, action) = maxValue(board: board)
            return action
        } else {
            let (_, action) = minValue(board: board)
            return action
        }
    }
    
    func maxValue(board: Board) -> (Int, Move?) {

        var value = MIN_VALUE
        var finalAction: Move? = nil

        if terminal(board: board) {
            return (utility(board: board), finalAction)
        }

        for action in moves(board: board) {
            let (minV, _) = minValue(board: result(board: board, move: action))

            // Since 1 is the max possible score, if we find that for max player no need to search further
            if minV == X_WINS {
                return (minV, action)
            } else if minV > value {
                finalAction = action
                value = minV
            }
        }
        return (value, finalAction)
    }

    func minValue(board: Board) -> (Int, Move?) {

        var value = MAX_VALUE
        var finalAction: Move? = nil

        if terminal(board: board) {
            return (utility(board: board), finalAction)
        }

        for action in moves(board: board) {
            let (maxV, _) = maxValue(board: result(board: board, move: action))

            // Since -1 is the min possible score, if we find that for min player no need to search further
            if maxV == O_WINS {
                return (maxV, action)
            } else if maxV < value {
                finalAction = action
                value = maxV
            }
        }
        return (value, finalAction)
    }
        
    func processPlayerMove(for position: Int) {
        guard !isSquareOccupied(in: board, at: position) else { return }
        board[position] = humanPlayer
        isGameBoardDisabled = true

        if terminal(board: board) {
            isGameBoardDisabled = false
            if winner(board: board) == humanPlayer {
                playerScore += 1
                alertItem = AlertContext.humanWin
            } else {
                playerScore += 0.5
                computerScore += 0.5
                alertItem = AlertContext.draw
            }
        } else {
            processComputerMove()
        }
    }
    
    func processComputerMove() {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            
            let startTime = Date().timeIntervalSince1970
            //Heavy operation takes time to calculate
            let computerPosition = minimax(board: board)
            let endTime = Date().timeIntervalSince1970
            let timeTaken = endTime - startTime
            
            //Show min delay of 0.5, if minimax takes more than 0.5 secs then no delay is required.
            var delay = 0.5 - timeTaken
            if delay < 0 {
                delay = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
                board[computerPosition!] = computerPlayer
                
                isGameBoardDisabled = false
                if terminal(board: board) {
                    if winner(board: board) == computerPlayer {
                        computerScore += 1
                        alertItem = AlertContext.computerWin
                    } else {
                        playerScore += 0.5
                        computerScore += 0.5
                        alertItem = AlertContext.draw
                    }
                }
            }
        }
    }
    
    func checkFirstMove() {
        if computerPlayer == .X {
            isGameBoardDisabled = true
            processComputerMove()
        } else {
            isGameBoardDisabled = false
        }
    }

    func isSquareOccupied(in board: Board, at index: Int) -> Bool {
        return board[index] != nil
    }

    func resetGame() {
        showStartScreen = true
        board = initialState()
    }
    
    //Human is playing as X
    func setHumanAsX() {
        humanPlayer = .X
        computerPlayer = .O
    }
    
    //Human is playing as O
    func setHumanAsO() {
        humanPlayer = .O
        computerPlayer = .X
    }
}

extension CGFloat {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
