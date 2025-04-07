// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Console.sol";
import {StableSwap} from "../src/StableSwap.sol";
import {Token} from "../src/tokens/Token.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public returns (StableSwap, Token[] memory) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.envAddress("DEPLOYER_ADDRESS");
        uint256 initialMint = vm.envUint("INITIAL_MINT");
        uint256 initialLiquidity = vm.envUint("INITIAL_LIQUIDITY");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy tokens
        Token[] memory tokens = new Token[](3);
        tokens[0] = new Token("Indonesian Rupiah eXchange", "IDRX", 18, initialMint);
        tokens[1] = new Token("USD Coin", "USDC", 6, initialMint);
        tokens[2] = new Token("Euro Coin", "EURC", 6, initialMint);

        // Send tokens to deployer if msg.sender is not the deployer
        if (msg.sender != deployerAddress) {
            for (uint256 i = 0; i < tokens.length; i++) {
                tokens[i].transfer(deployerAddress, initialMint / 2); // Send half of supply to deployer
            }
        }

        // Deploy StableSwap with token addresses
        address[3] memory tokenAddresses;
        tokenAddresses[0] = address(tokens[0]);
        tokenAddresses[1] = address(tokens[1]);
        tokenAddresses[2] = address(tokens[2]);
        
        StableSwap stableSwap = new StableSwap(tokenAddresses);

        // Add initial liquidity
        for (uint256 i = 0; i < tokens.length; i++) {
            tokens[i].approve(address(stableSwap), initialLiquidity);
        }

        uint256[3] memory amounts;
        amounts[0] = initialLiquidity;
        amounts[1] = initialLiquidity;
        amounts[2] = initialLiquidity;
        
        stableSwap.addLiquidity(amounts, 0);

        vm.stopBroadcast();

        // Log deployed addresses
        console.log("Deployed Contracts:");
        console.log("------------------");
        console.log("StableSwap:", address(stableSwap));
        console.log("IDRX:", address(tokens[0]));
        console.log("USDC:", address(tokens[1]));
        console.log("EURC:", address(tokens[2]));
        console.log("\nToken Balances:");
        console.log("---------------");
        console.log("IDRX balance:", tokens[0].balanceOf(deployerAddress));
        console.log("USDC balance:", tokens[1].balanceOf(deployerAddress));
        console.log("EURC balance:", tokens[2].balanceOf(deployerAddress));

        return (stableSwap, tokens);
    }
} 