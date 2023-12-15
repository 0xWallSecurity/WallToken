// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

import {Script} from "forge-std/Script.sol";
import {WallToken} from "../src/WallToken.sol";
import {DeployHelper} from "./DeployHelper.s.sol";

contract DeployWallToken is Script {
    WallToken wallToken;
    DeployHelper deployHelper;

    function run() external returns (WallToken, DeployHelper) {
        deployHelper = new DeployHelper();
        (string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals, uint256 tokenSupply, uint256 deployKey) = deployHelper.deployConfig();

        vm.startBroadcast(deployKey);
        wallToken = new WallToken(tokenName, tokenSymbol, tokenDecimals, tokenSupply);
        vm.stopBroadcast();

        return (wallToken, deployHelper);
    }
}