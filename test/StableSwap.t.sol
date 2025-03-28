// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/Token.sol";
import "../src/StableSwap.sol";

contract StableSwapTest is Test {
    Token public xidr;
    Token public usdc;
    Token public usdt;
    StableSwap public swap;

    // address public user = address(1);

    function setUp() public {
        // Deploy mock tokens with different decimals
        xidr = new Token("XIDR", "XIDR", 18, 1_000_000e18);
        usdc = new Token("USDC", "USDC", 6, 1_000_000e6);
        usdt = new Token("USDT", "USDT", 6, 1_000_000e6);
    
        // Deploy the StableSwap contract with 3 tokens
        address[3] memory tokens = [address(xidr), address(usdc), address(usdt)];
        swap = new StableSwap(tokens);
    }

    // function testMintedBalances() public {
    //     // Check if deployer got initial supply
    //     assertEq(xidr.balanceOf(address(this)), 1_000_000e18);
    //     assertEq(usdc.balanceOf(address(this)), 1_000_000e6);
    //     assertEq(usdt.balanceOf(address(this)), 1_000_000e6);
    // }

    function testDeployment() public {
        // Check token addresses are correct
        assertEq(swap.tokens(0), address(xidr));
        assertEq(swap.tokens(1), address(usdc));
        assertEq(swap.tokens(2), address(usdt));
    }

}

