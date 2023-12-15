//SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import {Script, console} from "forge-std/Script.sol";

contract DeployHelper is Script {
    uint256 private ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    DeployConfig public deployConfig;

    struct DeployConfig {
        string tokenName;
        string tokenSymbol;
        uint8 tokenDecimals;
        uint256 tokenSupply;
        uint256 deployKey;
    }

    constructor() {
        // anvil
        if (block.chainid == 31337) {
            deployConfig = setAnvilConfig();
        }
    }

    function setAnvilConfig() public returns (DeployConfig memory anvilDeployConfig) {
        anvilDeployConfig = DeployConfig({
            tokenName: "Wall Token",
            tokenSymbol: "WTK",
            tokenDecimals: 18,
            tokenSupply: 1000 ether,
            deployKey: ANVIL_PRIVATE_KEY
        });
    }
}