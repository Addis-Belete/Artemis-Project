//SPDX-License-Identifier: Unlicense
 pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

interface IreceiptToken {
function mint(uint256 amount, address to) external;
function burn(uint256 amount, address from) external;


}
 contract DAIPool {
     // This contract gives 30% APY for stakers
  address private DAIAddress = 0x73967c6a0904aA032C103b4104747E88c566B1A2;
  struct userInfo {
      
      uint256 amount;
      uint256 dep_started;
      bool isDeposited;
  }   
  IERC20 DAI = IERC20(DAIAddress);
  mapping(address => userInfo) public UserBalance;
/*
@notice - Function used to deposit DAI to the pool
@param - amount - user wants to deposit to the pool
*/
function deposit(uint256 amount) public {
   require(DAI.balanceOf(msg.sender) > amount, "You don't have enough amount to stake");
   DAI.transfer(address(this), amount);
   UserBalance[msg.sender] = userInfo(amount, block.timestamp, true); 

}

     
 }