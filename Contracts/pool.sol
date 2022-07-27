//SPDX-License-Identifier: Unlicense
 pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
 contract DAIPool {
     // This contract gives 30% APY for stakers
address private DAI = 0x73967c6a0904aA032C103b4104747E88c566B1A2;
  struct userInfo {
      address owner;
      uint256 amount;
      uint256 dep_started;
      bool isDeposited;
  }   

  mapping(address => userInfo) public UserBalance;
/*
@notice - Function used to deposit DAI to the pool
@param - amount - user wants to deposit to the pool
*/
function deposit(uint256 amount) public {

}

     
 }