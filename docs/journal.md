# Developer Journal

This journal is a log of the various improvements each developer made during the game jam.

## 11/7/2020

The game jam has begun! The team had a meetup to discuss ideas for a game with Coopertition. We came up with 3 main ideas:

- An **earth sim** where each nation is competing for resources but protecting the whole planet against an imminent threat like asteroids, alien attacks, climate change, etc.
- A **cooperative paltformer game** competing for points, ala multiplayer platformers where the highest score wins. Optionally working together to solve puzzles with more intricate solutions scoring more points.
- **Wait staff sim** where the players control waiters competing at a restaurant for tips. Helping other wait staff's customers makes everyone in the restaurant happier and tip more, but you want to get the most tips.
- **FRC Pit Crew** game where you have to repair your team's robot as it is constantly being broken during matches. You also have to go to other pit crews to trade for parts and help them repair.

We quickly settled on the Earth Sim with an asteroid threat, missiles and laser defense, and any nation being destroyed means game over for everyone.

Here is our [brainstorm](brainstorm.md) document we came up with while throwing out ideas.

### OS

Created initial gamejam project
![Project Setup](JournalImages/2020-11-07-01.png)

### CP

Network testing with godot, can we use a dedicated server? Yes.

### SM

Tech Tree and Research Screen Mockup
![Research Tree](JournalImages/2020-11-07-02.png)

### EP

Create icons and set tone for art style.
![Icons](JournalImages/2020-11-07-03.png)

### IB

Researched menu designing godot

---

## 11/9/2020

### OS

Created Player and World scenes and Signals Singleton. Also created camera system for the map
![zoom pan](JournalImages/zoompan.gif)

### CP

Design and task management.
More networking.
Managed to get the client and server in sync
![sync](JournalImages/clientserversycn.png)

### SM

Tech Tree godot screen layout
![Tech Tree](JournalImages/2020-11-08-02.png)

### EP

Map design
![Map](JournalImages/2020-11-08-01.jpeg)

### IB

...

---

## 11/10/2020

### OS

Buildings can be placed on territories, and they also cost resources.
![Building Placement](JournalImages/2020-11-10-01.gif)

### CP

- Assisted student with asteroid logic and gdscript issues.
- Added get_territories() logic to get all territories in a map for asteroid selection.
- Worked on PlayersManager to create 5 human or ai players and manage all their data

### SM

...

### EP

Initial asteroid mechanic implemented
![asteroid](JournalImages/asteroid.gif)

### IB

Began designing menu system

---

## 11/11/2020

### OS

Worked on cursor changing based on whether or not a building is being placed or not

### CP

More networking work today. Player Management is better structured, and each player that joins and assumes one of the AI players.

![Player Names in Sync](JournalImages/2020-11-11-03.png)

### SM

...

### EP

Asteroids now destroy tiles!
![asteroid destroy](JournalImages/asteroidsdestroy.gif)

### IB

Menu Mockups
![Menu Mockup1](JournalImages/2020-11-11-01.jpg)
![Menu Mockup2](JournalImages/2020-11-11-02.jpg)

---

## 11/12/2020

### OS

Working on asteroids destroying the buildings on a destroyed tiles.
As you can see in this gif.. it didn't exactly pan out in the beginning

![Asteroid Destruction](JournalImages/2020-11-12-01.gif)

### CP

More networking to fix players joining and assuming AI. Added multiplayer support for asteroid spawning, position and impact.
Also added support for multiplayer building placement!

![networkas](JournalImages/Networked-Asteroids.gif)
![netowrkbuild](JournalImages/Networked-Building-Placement.gif)

### SM

Worked on tech tree, nodes change based on whether or not players can research a tech, and it shows a progress bar!
![techtree](JournalImages/tecthree.gif)

### EP

Worked on a wave system for the asteroids!
![wave](JournalImages/asteoridwave.gif)

### IB

...

---

## 11/13/2020

### OS

...

### CP

- New HUD
  ![HUD](JournalImages/2020-11-13-01.png)

- Players can now give gifts to other players. Coopertition mode enabled!
- Each button turns into a plus icon when you hover over it.

![HUD with resources](JournalImages/2020-11-13-02.png)

- Music! Ievan Polkka, but less dancing cats and more techno.
- LASER NOISES. Pew Pew!
- Click sound
- New gifting icons

![Gift Icons](JournalImages/2020-11-13-03.png)
![Gift Plus Icon](JournalImages/2020-11-13-04.png)

- Added networked asteroid destroy event

### SM

...

### EP

Worked on balance, and added lasers!
![Lasers](JournalImages/LasersShootingAsteroid.png)

### IB

...

---

## 11/14/2020

### OS

...

### CP

- Main Menu, Settings + Host/Join + Lobby menus written

![Let's All Go to the Lobby](JournalImages/2020-11-14-01.png)

- Shield events syncing over network
- Tested multiplayer over local network with EP

![Local Network Multiplayer Test](JournalImages/2020-11-14-02.png)

**Quality of life improvements**

- Added settings to disable music and saving port/host for next session
- Added display for which asteroid wave we're on
- Made end game conditions disconnect from the network

### SM

...

### EP

Buildings improve with research!
![<Tier-3 Laser>](JournalImages/HighTechLaser.png)

### IB

...

---

## 11/15/2020

### OS

...

### CP

**More Quality of life improvements**

- Wave `n` of `m` title text
- Final asteroid countdown timer
- Easy mode
- Asteroid strike noise to complement OS's screen shake!
- Added EP's human/robot icons to lobby
- Leaderboard/Tech Tree icons so SM's awesome features will be discoverable

![Little Icons!](JournalImages/2020-11-15-01.png)

**LOTS of multiplayer fixes**

- Throw error popup if the server disconnects you
- Moved a bunch of less important things to use udp for network
- Changed player/asteroid serialization to use array instead of dict
- Finally located networking bug that was causing an infinite RPC loop between server -> client -> server -> client, etc

Most importantly, the team all played a multiplayer game together and WON! Hooray!

### SM

...

### EP

Updated documentation, last minute fixes and improvements!
[README](../README.md)

### IB

...
