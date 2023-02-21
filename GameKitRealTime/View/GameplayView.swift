//
//  GameplayView.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import SwiftUI

struct GameplayView: View {
    @EnvironmentObject var game: Game
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    game.quitGame()
                } label: {
                    Label("quit", systemImage: "x.circle")
                }
                .buttonStyle(.bordered)
            }
            
            ForEach(game.opponents) { opponent in
                HStack {
                    opponent.avatar
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60.0, height: 60.0)
                        .clipShape(Circle())
                    
                    Text(opponent.gkPlayer.displayName)
                    
                    Spacer()
                    
                    Text(opponent.numberOfTaps.description)
                }
            }
            
            if game.localPlayer != nil {
                HStack {
                    game.localPlayer!.avatar
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60.0, height: 60.0)
                        .clipShape(Circle())
                    
                    Text(game.localPlayer!.gkPlayer.displayName)
                }
                
                Text(game.localPlayer!.numberOfTaps.description)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Button {
                game.localPlayer?.numberOfTaps += 1
                game.sendNewScore()
            } label: {
                Text("Tap")
                    .font(.largeTitle)
                    .fontWeight(.black)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct GameplayView_Previews: PreviewProvider {
    static var previews: some View {
        GameplayView()
            .environmentObject(Game())
    }
}
