# Creating real-time games

Develop games where multiple players can play simultaneously.

## Overview

This sample code project uses the GameKit framework to create a simple real-time game where players compete to tap faster than their opponent.

To create your own real-time game, replace the SwiftUI files with your gameplay interface, and modify the Game class to support your game.

## Configure the sample code project

To configure the sample code project, perform the following steps in Xcode:

1. Change the Bundle Identifier to a unique ID on the Signing & Capabilities pane.
2. Add your Apple ID account and assign the target to a team so Xcode can enable Game Center.
3. Add an App Icon to the target.
4. In App Store Connect, create an app record that matches the bundle ID (see Add a new app in App Store Connect Help).
5. Connect two iOS devices to your Mac.
6. If necessary, click Register Device in the Signing & Capabilities pane to create the provisioning profile.
7. Build and run the sample on the two iOS devices.
8. If the Welcome to Game Center sheet appears, sign in using a different Apple ID on each device.

## Documentation

Check out the documentation for more information:
https://developer.apple.com/documentation/gamekit/finding_multiple_players_for_a_game
