// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

import {V2Router, IYearnV2} from "./V2Router.sol";
import {IStrategyInterface} from "./interfaces/IStrategyInterface.sol";

contract V2RouterFactory {
    event NewV2Router(address indexed strategy, address indexed asset);

    /**
     * @notice Deploy a new V2 Router.
     * @dev This will set the msg.sender to all of the permissioned roles.
     * @param _v2Vault The V2 vault to use for yield.
     * @param _name The name for the lender to use.
     * @return . The address of the new lender.
     */
    function newV2Router(address _v2Vault, string memory _name)
        external
        returns (address)
    {
        return newV2Router(_v2Vault, _name, msg.sender, msg.sender, msg.sender);
    }

    /**
     * @notice Deploy a new V2 Router.
     * @param _v2Vault The V2 vault to use for yield.
     * @param _name The name for the strategy to use.
     * @param _management Address to set as strategy management.
     * @param _performanceFeeRecipient Address to receive fees.
     * @param _keeper Address to be allowed to report.
     * @return . The address of the new strategy.
     */
    function newV2Router(
        address _v2Vault,
        string memory _name,
        address _management,
        address _performanceFeeRecipient,
        address _keeper
    ) public returns (address) {
        address _asset = IYearnV2(_v2Vault).token();

        // We need to use the custom interface with the
        // tokenized strategies available setters.
        IStrategyInterface newStrategy = IStrategyInterface(
            address(new V2Router(_asset, _name, _v2Vault))
        );

        newStrategy.setPerformanceFeeRecipient(_performanceFeeRecipient);

        newStrategy.setKeeper(_keeper);

        newStrategy.setPendingManagement(_management);

        emit NewV2Router(address(newStrategy), _asset);

        return address(newStrategy);
    }
}
