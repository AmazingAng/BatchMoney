// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IBatchTransfer {
	function batchTransferERC20(address token, uint256 total, address[] memory recipients, uint256[] memory amounts) external;
    function batchTransferETH(address[] memory recipients, uint256[] memory amounts) external payable;
}
