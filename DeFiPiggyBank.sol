// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DeFi Piggy Bank (Simplified)
/// @notice Users can lock ETH and withdraw later with simulated interest.
contract DeFiPiggyBank {
    /// @notice Represents a user's deposit info
    struct Deposit {
        uint256 amount;  // Amount deposited
        uint256 timestamp; // When the deposit was made
        bool withdrawn; // Whether the user has withdrawn
    }

    /// @notice Mapping of user addresses to their deposit records
    mapping(address => Deposit) public deposits;

    /// @notice Interest multiplier (e.g., 110 means +10%)
    uint256 public interestMultiplier;

    /// @notice Lock period in seconds (e.g., 7 days)
    uint256 public lockPeriod;

    /// @notice Contract owner
    address public owner;

    /// @notice Sets initial interest and lock period
    /// @param _interestMultiplier e.g., 110 means 10% extra
    /// @param _lockPeriod Lock duration in seconds
    constructor(uint256 _interestMultiplier, uint256 _lockPeriod) {
        require(_interestMultiplier >= 100, "Multiplier must be >= 100");
        owner = msg.sender;
        interestMultiplier = _interestMultiplier;
        lockPeriod = _lockPeriod;
    }

    /// @notice Users deposit ETH into the piggy bank
    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");
        require(deposits[msg.sender].amount == 0, "Already deposited");

        deposits[msg.sender] = Deposit({
            amount: msg.value,
            timestamp: block.timestamp,
            withdrawn: false
        });
    }

    /// @notice Withdraw ETH after lock period
    function withdraw() external {
        Deposit storage userDeposit = deposits[msg.sender];
        require(userDeposit.amount > 0, "No deposit");
        require(!userDeposit.withdrawn, "Already withdrawn");

        uint256 unlockTime = userDeposit.timestamp + lockPeriod;
        require(block.timestamp >= unlockTime, "Lock period not over yet.");

        uint256 payout = userDeposit.amount;

        userDeposit.withdrawn = true;
        (bool success, ) = payable(msg.sender).call{value: payout}("");
        require(success, "Withdraw failed.");
    }

    /// @notice Returns how many seconds are left before a user can withdraw
    /// @param user The address of the depositor
    /// @return secondsLeft Time remaining in seconds
    function getRemainingLockTime(address user) external view returns (uint256 secondsLeft) {
        Deposit storage userDeposit = deposits[user];
        require(userDeposit.amount > 0, "No deposit");

        uint256 unlockTime = userDeposit.timestamp + lockPeriod;

        if (block.timestamp >= unlockTime) {
            return 0;
        } else {
            return unlockTime - block.timestamp;
        }
    }
}