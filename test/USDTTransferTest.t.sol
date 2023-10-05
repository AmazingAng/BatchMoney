// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";


contract USDTTransferTest is Test {
    IBatchTransfer iBatch;
    USDT usdt;

    address address0 = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
    address[] recipients;
    uint[] amounts;
    uint total;

    /// @dev Setup the testing environment.
    function setUp() public {
        iBatch = IBatchTransfer(HuffDeployer.deploy("BatchTransfer"));
        usdt = new USDT("USDT","USDT");

        for(uint i; i < 1000; i++){
            recipients.push(address(uint160(address0)+uint160(i)));
            amounts.push(i);
            total += i;
        }
        vm.deal(address0, 1000 ether);
        usdt.mint(address0, total);
    }


    function testBatchTransferUSDT() public {
        vm.startPrank(address0);
        usdt.approve(address(iBatch), total);
        iBatch.batchTransferERC20(address(usdt), total, recipients, amounts);
        vm.stopPrank();
    }
}

interface IBatchTransfer {
	function batchTransferERC20(address token, uint256 total, address[] memory recipients, uint256[] memory amounts) external;
    function batchTransferETH(address[] memory recipients, uint256[] memory amounts) external payable;
}

// no return data from transfer/transferFrom/approve
interface IUSDT {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external;
    function transferFrom(address from, address to, uint256 amount) external;
}

contract USDT is IUSDT {

    mapping(address => uint256) public override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    uint256 public override totalSupply;   // 代币总供给

    string public name;   // 名称
    string public symbol;  // 符号
    
    uint8 public decimals = 18; // 小数位数

    // @dev 在合约部署的时候实现合约名称和符号
    constructor(string memory name_, string memory symbol_){
        name = name_;
        symbol = symbol_;
    }

    // @dev 实现`transfer`函数，代币转账逻辑
    function transfer(address recipient, uint amount) external override {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }

    // @dev 实现 `approve` 函数, 代币授权逻辑
    function approve(address spender, uint amount) external override{
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    // @dev 实现`transferFrom`函数，代币授权转账逻辑
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override{
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    // @dev 铸造代币，从 `0` 地址转账给 调用者地址
    function mint(address to, uint amount) external {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    // @dev 销毁代币，从 调用者地址 转账给  `0` 地址
    function burn(address from, uint amount) external {
        balanceOf[from] -= amount;
        totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }

}