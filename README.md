![License](https://img.shields.io/badge/license-Apache%202.0-blue) ![Assembly 68k](https://img.shields.io/badge/language-Assembly%2068k-yellow)


## Table of Contents

- [Game of Life](#game-of-life)
- [Prerequisites](#prerequisites)
- [Features](#Features)
- [Installation](#installation)
- [Usage and Demonstration](#usage-and-demonstration)
- [Authors](#authors)
- [License](#license)

# Game-of-life

This program was created by **TALAB Stéphane** as part of a computer architecture project, conducted during the 2024-2025 academic year in the second year of the Computer Science bachelor's degree at UPJV Amiens.

The project implements the famous **"Game of Life"**, designed by mathematician **John Horton Conway** in 1970. This cellular automaton is renowned for its fascinating emergent properties. The program is based on an implementation in 68k assembly language, a programming language that operates very close to the hardware.




## Prerequisites

To run this code, you need to install the **EASy68k** software.

- **Link to download and install EASy68k** :

  [http://www.easy68k.com/](http://www.easy68k.com/)


## Features

- Simulation of Conway's Game of Life rules (birth, survival, and death of cells)
- Customizable speed
- Save and load simulation states (The game automatically adds the `.schematic` extension if needed)
- Random system to initialize the grid
- Runs on 68k assembly emulator
- Pre-created demonstration files ready for use

## Installation

Clone the project

```bash
  git clone https://github.com/ProGen18/JDVarchi
```

Go to the project directory

```bash
  cd JDVarchi
```


- Launch the **EASy68k** application.
- Go to **File** > **Open** and select the `main.X68` file from the project folder.


Once your project file is opened, press **F9** to assemble the code. Execute it.


After the assembly is finished, press **F9** again to run the program and enjoy.


## Usage-and-demonstration

![Demonstration Conway's Game of Life](https://pouch.jumpshare.com/preview/QAIOp5QARWMNKIfSW86VgRpEuuAtyPpGwcqEU5zZWTsOjMWbO1zCtv8yvPok4Qeg-XXJxOMdpmwj8QffV_MflT02Wne5xsuybODMpLQhqAs)

## Authors

- [Stephane TALAB](https://github.com/ProGen18)

## Licence

This project is licensed under the [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) license.
You are free to use, modify, and redistribute this code, but you must comply with the terms of the license, including crediting the original author and including a copy of the license with any redistribution.

