// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { console } from "forge-std/console.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeETH is Ownable {
    uint public balance;
    address public tokenAddress;

    mapping(address => uint) public remainingBalance;

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function deposit(IERC20 _tokenAddress, uint amount) public {
        require(address(_tokenAddress) == tokenAddress);
        require(_tokenAddress.allowance(msg.sender, address(this)) >= amount);
        require(_tokenAddress.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        remainingBalance[msg.sender] += amount;
        balance += amount;
    }

    function withdraw(IERC20 _tokenAddress, uint amount) public {
        require(remainingBalance[msg.sender] >= amount, "Insufficient balance");
        require(_tokenAddress.transfer(msg.sender, amount));
        remainingBalance[msg.sender] -= amount;
        balance -= amount;
    }
}
