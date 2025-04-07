// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {StableSwap} from "../../src/StableSwap.sol";
import {Token} from "../../src/tokens/Token.sol";

contract TestUtils is Test {
    // Common variables
    uint256 public constant TOKENS_COUNT = 3;
    uint256 public initialMint;
    uint256 public initialLiquidity;
    
    // Test accounts
    address public owner;
    address public user1;
    address public user2;
    
    // Contracts
    StableSwap public pool;
    Token public idrx;   // IDRX token
    Token public usdc;   // USDC token
    Token public eurc;   // EURC token
    
    function setUp() public virtual {
        // Load configuration from environment
        initialMint = vm.envUint("INITIAL_MINT");
        initialLiquidity = vm.envUint("INITIAL_LIQUIDITY");
        
        // Set up accounts
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        
        vm.startPrank(owner);
        
        // Deploy tokens with initial supply
        idrx = new Token("Indonesian Rupiah eXchange", "IDRX", 6, initialMint);
        usdc = new Token("USD Coin", "USDC", 6, initialMint);
        eurc = new Token("Euro Coin", "EURC", 6, initialMint);
        
        // Deploy pool with token addresses
        address[3] memory tokenAddresses;
        tokenAddresses[0] = address(idrx);
        tokenAddresses[1] = address(usdc);
        tokenAddresses[2] = address(eurc);
        
        pool = new StableSwap(tokenAddresses);
        
        // Transfer initial amounts to test accounts
        transferInitialBalances(user1);
        transferInitialBalances(user2);
        
        vm.stopPrank();
    }
    
    function transferInitialBalances(address user) internal {
        uint256 amount = initialMint / 4; // Give each test user 1/4 of initial mint
        idrx.transfer(user, amount);
        usdc.transfer(user, amount);
        eurc.transfer(user, amount);
    }
    
    function addInitialLiquidity() public {
        vm.startPrank(owner);
        uint256[3] memory amounts;
        amounts[0] = initialLiquidity;
        amounts[1] = initialLiquidity;
        amounts[2] = initialLiquidity;
        
        approvePool(owner);
        pool.addLiquidity(amounts, 0);
        vm.stopPrank();
    }
    
    function approvePool(address user) public {
        vm.startPrank(user);
        idrx.approve(address(pool), type(uint256).max);
        usdc.approve(address(pool), type(uint256).max);
        eurc.approve(address(pool), type(uint256).max);
        vm.stopPrank();
    }
    
    function getTokenBalance(address token, address user) public view returns (uint256) {
        return Token(token).balanceOf(user);
    }
} 