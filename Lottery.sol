// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicLottery {
    address public owner;
    address payable[] public players;
    uint256 public constant ticketPrice = 0.01 ether;
    bool public open;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyWhenOpen() {
        require(open, "Lottery not open");
        _;
    }

    // Because constructors are disallowed, use this initialization function.
    // It must be called once by the deployer to open the lottery.
    function startLottery() external {
        require(owner == address(0), "Already initialized");
        owner = msg.sender;
        open = true;
    }

    // Players enter by sending exactly ticketPrice and calling this function.
    function enter() external payable onlyWhenOpen {
        require(msg.value == ticketPrice, "Send exact ticket price");
        players.push(payable(msg.sender));
    }

    // Returns list of players (addresses)
    function getPlayers() external view returns (address payable[] memory) {
        return players;
    }

    // Returns contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Owner can pick a winner. Uses a pseudo-random value derived from block data.
    // WARNING: This method is NOT secure against manipulation and should not be used in production
    // where real money or high-value prizes are at stake. Use an on-chain VRF (e.g., Chainlink VRF)
    // in production for tamper-resistant randomness.
    function pickWinner() external onlyOwner onlyWhenOpen {
        require(players.length > 0, "No players");
        // Pseudo-random (insecure) — DO NOT use in production
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, players.length)
            )
        );
        uint256 winnerIndex = random % players.length;
        address payable winner = players[winnerIndex];

        // Close lottery before transferring to avoid reentrancy issues
        open = false;

        // Send entire balance to winner
        (bool sent, ) = winner.call{value: address(this).balance}("");
        require(sent, "Transfer failed");

        // Reset players for next round (owner can start again by calling reset/startLottery pattern)
        delete players;
    }

    // Allow owner to reopen for a new round (no params)
    function reopen() external onlyOwner {
        require(!open, "Already open");
        open = true;
    }

    // Emergency: owner can withdraw funds (if needed). Only owner and only when closed.
    function emergencyWithdraw() external onlyOwner {
        require(!open, "Close lottery first");
        uint256 bal = address(this).balance;
        require(bal > 0, "No balance");
        (bool sent, ) = payable(owner).call{value: bal}("");
        require(sent, "Withdraw failed");
    }

    // Fallback / receive so contract can accept ETH (but enter() enforces correct ticket price)
    receive() external payable {}
}
