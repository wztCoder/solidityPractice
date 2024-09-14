// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Bank {
    //状态变量
    address public immutable owner;
    bool private isClosed = false;  // 用于标记合约是否已关闭

    //事件
    event Deposit(address indexed _ads, uint256 amount);
    event Withdraw(uint256 amount);

    //receive接收ETH的函数
    receive() external payable {
        require(!isClosed, "Contract is closed");
        emit Deposit(msg.sender, msg.value);
    }

    //构造函数
    constructor() payable {
        owner = msg.sender;
    }

    //方法
    function withdraw() external {
        require(msg.sender == owner, "Not Owner");
        require(!isClosed, "Contract is closed");

        emit Withdraw(address(this).balance);
        
        // 将合约中的所有余额转移给合约所有者
        payable(msg.sender).transfer(address(this).balance);
        
        // 标记合约为已关闭状态
        isClosed = true;
    }

    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }
}