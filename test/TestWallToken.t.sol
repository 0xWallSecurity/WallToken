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
        (tokenName, tokenSymbol, tokenDecimals, tokenSupply, deployKey) = deployHelper.deployConfig();
        deployerAddress = vm.addr(deployKey);
        vm.prank(deployerAddress);
        wallToken.transfer(testerAddress, tokenSupply);
    }

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

    function testUserCannotTransferExceedingTokens() public {
        vm.startPrank(testerAddress);
        uint256 balance = wallToken.balanceOf(testerAddress);

        vm.expectRevert(WallToken__NotEnoughTokens.selector);
        wallToken.transfer(deployerAddress, balance + 1);
        vm.stopPrank();
    }
}