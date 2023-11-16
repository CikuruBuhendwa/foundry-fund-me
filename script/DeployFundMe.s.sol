// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() public returns (FundMe) {
        // Before startBoroadcast(), it is not a real tx
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPrideFeed = helperConfig.activeHelperConfig();

        // After startBoroadcast(), it is a real tx!!
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPrideFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
