// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BatchTransferTest is Test {
    IBatchTransfer iBatch;

    MyToken token0;
    MyToken token1;
    MyToken token2;

    Disperse disperse;
    address address0 = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
    address[] recipients;
    uint[] amounts;
    uint total;

    /// @dev Setup the testing environment.
    function setUp() public {
        token0 = new MyToken("Token","TKN");
        token1 = new MyToken("Token","TKN");
        token2 = new MyToken("Token","TKN");
        iBatch = IBatchTransfer(HuffDeployer.deploy("BatchTransfer"));
        disperse = new Disperse();

        for(uint i; i < 1000; i++){
            recipients.push(address(uint160(address0)+uint160(i)));
            amounts.push(i);
            total += i;
        }
        vm.deal(address0, 1000 ether);

        token0.mint(address0, total * 10);
        token1.mint(address0, total * 10);
        token2.mint(address0, total * 10);
        vm.startPrank(address0);
        token0.approve(address(iBatch), total);
        token1.approve(address(disperse), total);
        vm.stopPrank();
    }

    function testBatchTransferDeploy() public {
        deploy(hex"61010980600a3d393df35f3560e01c8063ae4edb2c1461001e578063a0ce91d8146100be575f5ffd5b600435602435306323b872dd5f52336020528060405281606052602060606064601c5f875af13d156060516001141716610056575f80fd5b60443560040180356064356004018035828114610071575f80fd5b600163a9059cbb5f525b8181116100bc578481602002013560205282816020020135604052602060606044601c5f8c5af13d1560605160011417166100b4575f80fd5b60010161007b565b005b600435600401803560243560040180358281146100d9575f80fd5b60015b818111610107575f80808086856020020135898660200201355af16100ff575f80fd5b6001016100dc565b00");
    }

    function testBatchTransferETH() public {
        vm.prank(address0);
        //console.log(address0.balance);
        iBatch.batchTransferETH{value: total}(recipients, amounts);
    }

    function testBatchTransferERC20() public {
        vm.prank(address0);
        //console.log(address0.balance);
        iBatch.batchTransferERC20(address(token0), total, recipients, amounts);
    }

    function testDisperseDeploy() public {
        deploy(type(Disperse).creationCode);
    }

    function testDisperseETH() public {
        vm.prank(address0);
        //console.log(address0.balance);
        disperse.disperseEther{value: total}(recipients, amounts);
    }

    function testDisperseERC20() public {
        vm.prank(address0);
        //console.log(address0.balance);
        disperse.disperseToken(IERC20(address(token1)), recipients, amounts);
    }

    function testSingleTransferERC20() public{
        vm.prank(address0);
        token2.transfer(recipients[100],1);
    }

    function deploy(bytes memory code) public payable returns (address addr) {
        assembly {
            // create(v, p, n)
            // v = amount of ETH to send
            // p = pointer in memory to start of code
            // n = size of code
            addr := create(callvalue(), add(code, 0x20), mload(code))
        }
        // return address 0 on error
        require(addr != address(0), "deploy failed");
    }
}

interface IBatchTransfer {
	function batchTransferERC20(address token, uint256 total, address[] memory recipients, uint256[] memory amounts) external;
    function batchTransferETH(address[] memory recipients, uint256[] memory amounts) external payable;
}

contract MyToken is ERC20{

    constructor (string memory _name, string memory _symbol) ERC20 (_name,_symbol){
    }

    function mint(address to, uint256 amount) public virtual {
        _mint(to,amount);
    }

    function burn(address form, uint amount) public virtual {
        _burn(form, amount);
    }
}

contract Disperse {
    function disperseEther(address[] memory recipients, uint256[] memory values) external payable {
        for (uint256 i = 0; i < recipients.length; i++){
            payable(recipients[i]).transfer(values[i]);
        }
        uint256 balance = address(this).balance;
        if (balance > 0)
            payable(msg.sender).transfer(balance);
    }

    function disperseToken(IERC20 token, address[] memory recipients, uint256[] memory values) external {
        uint256 total = 0;
        for (uint256 i = 0; i < recipients.length; i++){
            total += values[i];
        }
        require(token.transferFrom(msg.sender, address(this), total));
        for (uint256 i = 0; i < recipients.length; i++){
            require(token.transfer(recipients[i], values[i]));
        }
    }

    function disperseTokenSimple(IERC20 token, address[] memory recipients, uint256[] memory values) external {
        for (uint256 i = 0; i < recipients.length; i++)
            require(token.transferFrom(msg.sender, recipients[i], values[i]));
    }
}