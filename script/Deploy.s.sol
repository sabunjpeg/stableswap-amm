// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {StableSwap} from "../src/StableSwap.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public returns (StableSwap) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy StableSwap
        // Parameters:
        // _n: number of tokens
        // _A: amplification coefficient
        // _fee: swap fee (1e8 = 100%)
        // _admin_fee: admin fee (1e8 = 100%)
        uint256 n = 2; // For a 2-token pool
        uint256 A = 200; // Amplification coefficient (typical range: 1-5000)
        uint256 fee = 4 * 1e6; // 0.04% swap fee
        uint256 admin_fee = 5 * 1e7; // 50% admin fee (of the swap fee)
        
        StableSwap stableSwap = new StableSwap(
            n,
            A,
            fee,
            admin_fee
        );

        vm.stopBroadcast();
        return stableSwap;
    }
} 