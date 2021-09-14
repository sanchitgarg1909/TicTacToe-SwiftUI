//
//  Constants.swift
//  TicTacToe
//
//  Created by Sanchit Garg on 01/09/21.
//

typealias Move = Int
typealias Board = [Player?]

enum Player: String {
    case X = "xmark",
         O = "circle"
}

let EMPTY: Player? = nil

// Game scores
let X_WINS = 1
let O_WINS = -1
let DRAW = 0

let MIN_VALUE = -2
let MAX_VALUE = 2
