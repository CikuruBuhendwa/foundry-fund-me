// SPDX-Licence-Identifier: MIT

// 1. Deploy mocks when on a local chain (anvil)
// 2. Keep track of different addresses for different chains

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If on a local chain, deploy mocks
    // Otherwise, use the right chain adresses

    NetworkConfig public activeHelperConfig;

    uint8 public constant ETH_DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeHelperConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeHelperConfig = getMainnetEthConfig();
        } else {
            activeHelperConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // priceFeed address
        return
            NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        // priceFeed address
        return
            NetworkConfig({
                priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // priceFeed address

        // Deploy mock contract
        // Return mock contract address

        if (activeHelperConfig.priceFeed != address(0)) {
            return activeHelperConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            ETH_DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        return NetworkConfig({priceFeed: address(mockPriceFeed)});
    }
}
