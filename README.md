# 🎟️ Basic Lottery Smart Contract (Flow Blockchain)

This project implements a **basic on-chain lottery system** where participants can enter by paying a fixed ticket price, and a random winner is selected at the end of each round.

> ⚡ Built for **Flow Blockchain Testnet**  
> 🧾 **Contract Address:** `0xa0B843EC6BA0BA49379Bd74Ee451a9C4a6460484`

---

## 🧩 Overview

The **Basic Lottery Contract** allows multiple participants to join by sending a small amount of tokens as a ticket price.  
Once enough players have joined, the contract owner can **pick a random winner**, who will automatically receive the entire pool balance.

This project demonstrates:
- On-chain randomness (pseudo-random using block data)
- Ownership control and permission-based functions
- ETH/Flow token handling within smart contracts
- Simple lifecycle: **start → enter → pick winner → reopen**

---

## 🏗️ Key Features

✅ **No Constructor & No External Imports**  
Designed with simplicity — no constructor, no external libraries, and no input parameters.

✅ **Pseudo-Random Winner Selection**  
Winner is chosen using a pseudo-random hash generated from block data.

✅ **Fixed Ticket Price**  
Each participant must send exactly `0.01 ether` (or equivalent Flow token on testnet).

✅ **Owner Controls**  
Only the owner can:
- Start or reopen the lottery
- Pick the winner
- Withdraw emergency funds (if needed)

✅ **Resettable Rounds**  
Once a round is closed, the owner can reopen it for a new lottery round.

---

## ⚙️ Smart Contract Details

| Field | Description |
|-------|--------------|
| **Ticket Price** | `0.01 ether` |
| **Network** | Flow Blockchain (Testnet) |
| **Contract Address** | `0xa0B843EC6BA0BA49379Bd74Ee451a9C4a6460484` |
| **Owner Role** | Deployer who initializes the lottery |
| **Randomness Source** | `keccak256(block.timestamp, block.difficulty, players.length)` *(not secure for production)* |

---

## 📜 Functions Overview

| Function | Description |
|-----------|--------------|
| `startLottery()` | Initializes the owner and opens the first lottery round |
| `enter()` | Allows a player to join the lottery by sending exactly 0.01 ether |
| `getPlayers()` | Returns the list of current participants |
| `getBalance()` | Returns the total balance in the contract |
| `pickWinner()` | Randomly selects a winner and transfers all funds |
| `reopen()` | Reopens the lottery for a new round |
| `emergencyWithdraw()` | Owner can withdraw funds if the lottery is closed |
| `receive()` | Accepts ETH deposits (for safety) |

---

## 🚀 How to Deploy & Test

### 1️⃣ Deploy the Contract
Deploy the `BasicLottery` contract to Flow Testnet.

### 2️⃣ Initialize the Lottery
After deployment, call:
