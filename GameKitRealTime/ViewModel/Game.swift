//
//  Game.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import SwiftUI
import GameKit

@MainActor class Game: NSObject, ObservableObject {
    @Published var localPlayer: Player?
    @Published var opponents: [Player] = []
    @Published var isAuthenticated = false
    
    @Published var isPlayingGame = false
    @Published var currentMatch: GKMatch?
    
    /// The root view controller of the window.
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    /// Authenticates the local player (i.e.: the user) with GameCenter.
    func authenticateLocalPlayer() {
        // Set the authentication handler that GameKit invokes.
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // If the view controller is non-nil, present it to the player so they can
                // perform some necessary action to complete authentication.
                self.rootViewController?.present(viewController, animated: true, completion: nil)
                return
            }
            if error != nil {
                // If you can’t authenticate the player, disable Game Center features in your game.
                print("Error: \(error!.localizedDescription).")
                return
            }
            
            // A value of nil for viewController indicates successful authentication, and you can access
            // local player properties.
            GKLocalPlayer.local.loadPhoto(for: GKPlayer.PhotoSize.small) { image, error in
                if let image = image {
                    // Create a Participant object to store the local player data.
                    self.localPlayer = Player(gkPlayer: GKLocalPlayer.local,
                                              avatar: Image(uiImage: image))
                }
                if error != nil {
                    // Handle an error if it occurs.
                    print("Error: \(error!.localizedDescription).")
                }
            }
            
            // Register for turn-based invitations and other events.
            GKLocalPlayer.local.register(self)
            
            // Enable the start game button.
            self.isAuthenticated = true
        }
    }
    
    /// Resets the game data to default
    func resetGame() {
        opponents = []
        isPlayingGame = false
        currentMatch = nil
    }
    
    /// Creates a new match request and shows the matchmaker view controller to find opponents.
    func startGame() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 4
        
        if let viewController = GKMatchmakerViewController(matchRequest: request) {
            viewController.matchmakerDelegate = self
            viewController.canStartWithMinimumPlayers = true
            
            self.rootViewController?.present(viewController, animated: true, completion: nil)
        } else {
            //View controller failed to present, handle this somehow
        }
    }
    
    /// Loads an avatar for a specific opponent, and places it in the correct opponent's Player struct
    func loadAvatar(for player: GKPlayer) {
        Task {
            let uiImage = try await player.loadPhoto(for: .small)
            if let index = opponents.firstIndex(where: { $0.gkPlayer.gamePlayerID == player.gamePlayerID }) {
                opponents[index].avatar = Image(uiImage: uiImage)
            }
        }
    }
    
    /// Send updated match data to all opponents
    func sendNewScore() {
        do {
            var gamePropertyList: [String: Any] = [:]
            
            // Add the local player's tap count.
            gamePropertyList["tapCount"] = localPlayer?.numberOfTaps
            
            let gameData = try PropertyListSerialization.data(fromPropertyList: gamePropertyList, format: .binary, options: 0)
            try currentMatch?.sendData(toAllPlayers: gameData, with: .reliable)
        } catch {
            //Handle error sending new score
            print("Error sending new score: \(error.localizedDescription)")
        }
    }
    
    /// Disconnects from the match and resets the game data
    func quitGame() {
        currentMatch?.disconnect()
        isPlayingGame = false
        resetGame()
    }
}
