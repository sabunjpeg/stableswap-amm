// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./utils/TestUtils.sol";

contract SwapTest is TestUtils {
    function setUp() public override {
        super.setUp();
        addInitialLiquidity();
    }

    function test_SwapIDRXtoUSDC() public {
        uint256 swapAmount = 1000 * 1e6; // 1000 IDRX
        uint256 minAmountOut = 990 * 1e6; // Expecting at least 990 USDC (allowing for 1% slippage)
        
        vm.startPrank(user1);
        approvePool(user1);
        
        uint256 beforeIDRX = idrx.balanceOf(user1);
        uint256 beforeUSDC = usdc.balanceOf(user1);
        
        pool.exchange(0, 1, swapAmount, minAmountOut);
        
        uint256 afterIDRX = idrx.balanceOf(user1);
        uint256 afterUSDC = usdc.balanceOf(user1);
        
        assertEq(beforeIDRX - afterIDRX, swapAmount, "Incorrect IDRX amount spent");
        assertTrue(afterUSDC > beforeUSDC, "USDC balance should increase");
        assertTrue(afterUSDC - beforeUSDC >= minAmountOut, "Received less than minimum amount");
        
        vm.stopPrank();
    }

    function test_SwapUSDCtoEURC() public {
        uint256 swapAmount = 1000 * 1e6; // 1000 USDC
        uint256 minAmountOut = 990 * 1e6; // Expecting at least 990 EURC (allowing for 1% slippage)
        
        vm.startPrank(user1);
        approvePool(user1);
        
        uint256 beforeUSDC = usdc.balanceOf(user1);
        uint256 beforeEURC = eurc.balanceOf(user1);
        
        pool.exchange(1, 2, swapAmount, minAmountOut);
        
        uint256 afterUSDC = usdc.balanceOf(user1);
        uint256 afterEURC = eurc.balanceOf(user1);
        
        assertEq(beforeUSDC - afterUSDC, swapAmount, "Incorrect USDC amount spent");
        assertTrue(afterEURC > beforeEURC, "EURC balance should increase");
        assertTrue(afterEURC - beforeEURC >= minAmountOut, "Received less than minimum amount");
        
        vm.stopPrank();
    }

    function test_SwapEURCtoIDRX() public {
        uint256 swapAmount = 1000 * 1e6; // 1000 EURC
        uint256 minAmountOut = 990 * 1e6; // Expecting at least 990 IDRX (allowing for 1% slippage)
        
        vm.startPrank(user1);
        approvePool(user1);
        
        uint256 beforeEURC = eurc.balanceOf(user1);
        uint256 beforeIDRX = idrx.balanceOf(user1);
        
        pool.exchange(2, 0, swapAmount, minAmountOut);
        
        uint256 afterEURC = eurc.balanceOf(user1);
        uint256 afterIDRX = idrx.balanceOf(user1);
        
        assertEq(beforeEURC - afterEURC, swapAmount, "Incorrect EURC amount spent");
        assertTrue(afterIDRX > beforeIDRX, "IDRX balance should increase");
        assertTrue(afterIDRX - beforeIDRX >= minAmountOut, "Received less than minimum amount");
        
        vm.stopPrank();
    }

    function test_RevertWhenSlippageTooHigh() public {
        uint256 swapAmount = 1_000_000 * 1e6; // 1M IDRX (very large amount)
        uint256 minAmountOut = 999_000 * 1e6; // Expecting 999k USDC (unrealistic given size)
        
        vm.startPrank(user1);
        approvePool(user1);
        
        vm.expectRevert(); // Should revert due to high slippage
        pool.exchange(0, 1, swapAmount, minAmountOut);
        
        vm.stopPrank();
    }

    function test_RevertWhenInsufficientBalance() public {
        uint256 swapAmount = 2_000_000 * 1e6; // 2M IDRX (more than initial balance)
        uint256 minAmountOut = 1_900_000 * 1e6;
        
        vm.startPrank(user2);
        approvePool(user2);
        
        vm.expectRevert(); // Should revert due to insufficient balance
        pool.exchange(0, 1, swapAmount, minAmountOut);
        
        vm.stopPrank();
    }
} 