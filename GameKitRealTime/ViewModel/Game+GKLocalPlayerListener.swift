//
//  Game+GKLocalPlayerListener.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import GameKit

extension Game: GKMatchDelegate, GKLocalPlayerListener {
    //Handle when the local player accepts an invite to a match
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        // Present the view controller in the invitation state.
        let viewController = GKMatchmakerViewController(invite: invite)
        viewController?.matchmakerDelegate = self
        rootViewController?.present(viewController!, animated: true, completion: nil)
    }
    
    //Handle when an opponent leaves the match
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        
        //Find the index of the player we are talking about
        if let index = opponents.firstIndex(where: { $0.gkPlayer.gamePlayerID == player.gamePlayerID }) {
            opponents.remove(at: index)
        }
        
        if opponents.isEmpty {
            quitGame()
        }
    }
    
    //Handle when an opponent sends us match data
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        //Ensure this data is for the current match
        guard currentMatch == match else {
            return
        }
        
        do {
            //Try to decode the data
            if let gamePropertyList: [String: Any] =
                try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] {
                
                // Restore the tapCount from the property list.
                if let newTaps = gamePropertyList["tapCount"] as? Int {
                    
                    //Find the index of the player we are talking about
                    if let index = opponents.firstIndex(where: { $0.gkPlayer.gamePlayerID == player.gamePlayerID }) {
                        opponents[index].numberOfTaps = newTaps
                    }
                }
            }
        } catch {
            //Handle error loading updated match data
            print("Error updating match data: \(error.localizedDescription)")
        }
    }
}
