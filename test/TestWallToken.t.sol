// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

import {Script} from "forge-std/Script.sol";
import {Test, console} from "forge-std/Test.sol";
import {WallToken} from "../src/WallToken.sol";
import {DeployHelper} from "../script/DeployHelper.s.sol";
import {DeployWallToken} from "../script/DeployWallToken.s.sol";

error WallToken__NotEnoughTokens();
error WallToken__MissingApproval();
error WallToken__CannotSendToZeroAddress();

contract TestWallToken is Script, Test {
    WallToken public wallToken;
    DeployHelper public deployHelper;
    DeployWallToken public deployWallToken;
    address public deployerAddress;
    address public testerAddress;
    address public approvedAddress;

    string tokenName;
    string tokenSymbol;
    uint8 tokenDecimals;
    uint256 tokenSupply;
    uint256 deployKey;

    function setUp() external {
        // setup contracts
        deployWallToken = new DeployWallToken();
        (wallToken, deployHelper) = deployWallToken.run();
        
        // setup addresses
        testerAddress = makeAddr("tester");
        approvedAddress = makeAddr("approvedTesterAddress");
        (tokenName, tokenSymbol, tokenDecimals, tokenSupply, deployKey) = deployHelper.deployConfig();
        deployerAddress = vm.addr(deployKey);
        vm.prank(deployerAddress);
        wallToken.transfer(testerAddress, tokenSupply);
    }

    ///////////////////////
    // Testcases Getters //
    ///////////////////////

    function testTokenName() public {
        assertEq(wallToken.name(), tokenName);
    }

    function testTokenSymbol() public {
        assertEq(wallToken.symbol(), tokenSymbol);
    }

    function testTokenDecimals() public {
        assertEq(wallToken.decimals(), tokenDecimals);
    }

    function testTokenTotalSupply() public {
        assertEq(wallToken.totalSupply(), tokenSupply*10**tokenDecimals);
    }

    ////////////////////////
    // Testcases Transfer //
    ////////////////////////

    function testUserCannotTransferExceedingTokens() public {
        uint256 balance = wallToken.balanceOf(testerAddress);

        vm.prank(testerAddress);
        vm.expectRevert(WallToken__NotEnoughTokens.selector);
        wallToken.transfer(deployerAddress, balance + 1);

    }

    function testUserCannotTransferToZeroAddress() public {
        uint256 balance = wallToken.balanceOf(testerAddress);

        vm.prank(testerAddress);
        vm.expectRevert(WallToken__CannotSendToZeroAddress.selector);
        wallToken.transfer(address(0), balance);
    }

    function testTransferDoesCorrectlyReduceTokenAmountOnSender() public {
        uint256 balance = wallToken.balanceOf(testerAddress);
        uint256 transferAmount = 1 ether;

        vm.prank(testerAddress);
        wallToken.transfer(deployerAddress, transferAmount);
        assertEq(wallToken.balanceOf(testerAddress), balance - transferAmount);
    }
    
    function testTransferDoesCorrectlyIncreaseTokenAmountOnReceiver() public {
        uint256 balance = wallToken.balanceOf(deployerAddress);
        uint256 transferAmount = 1 ether;

        vm.prank(testerAddress);
        wallToken.transfer(deployerAddress, transferAmount);
        assertEq(wallToken.balanceOf(deployerAddress), balance + transferAmount);
    }

    ////////////////////////////
    // Testcases transferFrom //
    ////////////////////////////
    
    modifier approved {
        uint256 balance = wallToken.balanceOf(testerAddress);
        vm.prank(testerAddress);
        wallToken.approve(approvedAddress, balance);
        _;
    }

    function testUserCannotTransferFromWithoutApproval() public {
        vm.prank(approvedAddress);
        vm.expectRevert(WallToken__MissingApproval.selector);
        wallToken.transferFrom(testerAddress, deployerAddress, 1 ether);
    }

    function testUserCannotTransferFromExceedingTokens() public {
        uint256 balance = wallToken.balanceOf(testerAddress);
        vm.prank(testerAddress);
        wallToken.approve(approvedAddress, balance + 1);

        vm.prank(approvedAddress);
        vm.expectRevert(WallToken__NotEnoughTokens.selector);
        wallToken.transferFrom(testerAddress, deployerAddress, balance + 1);
    }

    function testUserCannotTransferFromToZeroAddress() public approved() {
        uint256 balance = wallToken.balanceOf(testerAddress);

        vm.prank(approvedAddress);
        vm.expectRevert(WallToken__CannotSendToZeroAddress.selector);
        wallToken.transferFrom(testerAddress, address(0), balance);
    }

    function testTransferFromDoesCorrectlyReduceTokenAmountOnSender() public approved() {
        uint256 balance = wallToken.balanceOf(testerAddress);
        uint256 transferAmount = 1 ether;

        vm.prank(approvedAddress);
        wallToken.transferFrom(testerAddress, deployerAddress, transferAmount);
        assertEq(wallToken.balanceOf(testerAddress), balance - transferAmount);
    }
    
    function testTransferFromDoesCorrectlyIncreaseTokenAmountOnReceiver() public approved() {
        uint256 balance = wallToken.balanceOf(deployerAddress);
        uint256 transferAmount = 1 ether;

        vm.prank(approvedAddress);
        wallToken.transferFrom(testerAddress, deployerAddress, transferAmount);
        assertEq(wallToken.balanceOf(deployerAddress), balance + transferAmount);
    }

        function testTransferFromDoesCorrectlyReduceAllowanceAmount() public approved() {
        uint256 allowance = wallToken.allowance(testerAddress, approvedAddress);
        uint256 transferAmount = 1 ether;

        vm.prank(approvedAddress);
        wallToken.transferFrom(testerAddress, deployerAddress, transferAmount);
        assertEq(wallToken.allowance(testerAddress, approvedAddress), allowance - transferAmount);
    }

}