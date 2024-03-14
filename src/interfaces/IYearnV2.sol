// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;

interface IYearnV2 {
    function token() external view returns (address);

    function totalAssets() external view returns (uint256);

    function depositLimit() external view returns (uint256);

    function deposit() external;

    function withdraw(uint256) external;

    function balanceOf(address) external view returns (uint256);

    function pricePerShare() external view returns (uint256);

    function withdrawalQueue(uint256) external view returns (address);
}
