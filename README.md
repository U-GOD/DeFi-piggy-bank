# 🐷 DeFi Piggy Bank (Simplified)

A smart contract that allows users to lock their ETH for a fixed period of time. Once the lock period is over, users can withdraw their original ETH deposit. This simulates a basic piggy bank mechanic often seen in savings apps.

---

## ✨ What This Contract Does

- Allows users to **deposit ETH** into a piggy bank.
- Each user can **only deposit once** (until they withdraw).
- ETH is locked for a **specified time period** (e.g., 1 minute, 7 days).
- After the lock period, users can **withdraw their ETH**.
- The contract owner sets the **lock period** and **interest multiplier** (can be used later to simulate yield).

---

## 🛠️ How It Works

- Each user's deposit is stored in a `struct` with:
  - `amount`: how much ETH was deposited
  - `timestamp`: when the deposit was made
  - `withdrawn`: whether the user has already withdrawn

- The `lockPeriod` is set during deployment (in seconds).
- An `interestMultiplier` is also set during deployment (currently defaults to 100%, so no extra ETH is added).
- No external yield sources or interest payouts are integrated (keeps logic clean and safe).

---

## 🧪 How to Interact (in Remix or frontends)

### ➕ 1. Deposit ETH
- In Remix, enter an ETH amount in the **Value** field (e.g. `0.001`) and click the `deposit()` button.
- Your ETH will be locked for the configured period.

### 🔍 2. Check Deposit
- Call `deposits(address)` with your wallet address.
- You'll see:
  ```json
  {
    amount: <ETH in wei>,
    timestamp: <unix time>,
    withdrawn: false
  }
