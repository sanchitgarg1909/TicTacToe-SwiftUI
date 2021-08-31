//
//  Alerts.swift
//  TicTacToe
//
//  Created by Sanchit Garg on 25/07/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You won"),
                                    message: Text("Congratulations!"),
                                    buttonTitle: Text("Let's go again"))
    static let computerWin = AlertItem(title: Text("You lost"),
                                    message: Text("Better luck next time!"),
                                    buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("It's a draw"),
                                    message: Text("You're both equally strong"),
                                    buttonTitle: Text("Try again"))
}
