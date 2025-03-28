# 🌀 StableSwap AMM – Foundry Implementation

A Curve-style StableSwap AMM implementation using [Foundry](https://book.getfoundry.sh/) to simulate and test swaps, liquidity provision, and removal. Built for composability and potential deployment on **Pharos Network**.

## 📜 Overview

This project implements a stable asset AMM using the StableSwap invariant that blends constant-sum and constant-product properties. It is designed to:
- Minimize slippage for similarly priced assets (e.g., stablecoins).
- Allow adding/removing liquidity with minimal impermanent loss.
- Be composable and deployable to EVM-compatible chains like Pharos.

## ⚙️ Invariant Formula
Invariant - price of trade and amount of liquidity are determined by this equation

An^n sum(x_i) + D = ADn^n + D^(n + 1) / (n^n prod(x_i))

Topics
0. Newton's method x_(n + 1) = x_n - f(x_n) / f'(x_n)
1. Invariant
2. Swap
   - Calculate Y
   - Calculate D
3. Get virtual price
4. Add liquidity
   - Imbalance fee
5. Remove liquidity
6. Remove liquidity one token
   - Calculate withdraw one token
   - getYD


## 🛠 Setup

> Ensure you have Foundry installed:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup