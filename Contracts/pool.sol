//SPDX-License-Identifier: Unlicense
 pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

interface IreceiptToken {
function mint(uint256 amount, address to) external;
function burn(uint256 amount, address from) external;
function balanceOf(address account) external view returns (uint256);


}
 contract DAIPool  {
     // This contract gives 30% APY for stakers
     // Reward calculated per month and added to the user Balance;
     address predefinedTokenAddress;
     address receiptTokenAddress;
     
   constructor(address _predefinedToken, address _receiptToken) {
   predefinedTokenAddress = _predefinedToken;
   receiptTokenAddress = _receiptToken;
   }  
  
  struct userInfo {
      uint256 amount;
      uint256 dep_started;
      bool isDeposited;
  }   

  IERC20 DAI = IERC20(predefinedTokenAddress);
  mapping(address => userInfo) public UserDetails;
/*
@notice - Function used to deposit DAI to the pool
@param - amount - user wants to deposit to the pool
*/
function deposit(uint256 amount) public {
   require(DAI.balanceOf(msg.sender) > amount, "You don't have enough amount to stake");
   DAI.transfer(address(this), amount);
   if(UserDetails[msg.sender].isDeposited == true){
   uint256 initialAmount = UserDetails[msg.sender].amount;
   uint256 initialTime = UserDetails[msg.sender].dep_started;
   uint256 reward = calculateReward(initialAmount, initialTime);
   uint256 finalAmount = initialAmount + amount + reward;
   UserDetails[msg.sender] = userInfo(finalAmount, block.timestamp, true);
      }
   else {
   UserDetails[msg.sender] = userInfo(amount, block.timestamp, true); 
   }
   IreceiptToken(receiptTokenAddress).mint(amount, msg.sender);
}
/*
@notice - Function used to withdraw funds from the contract
@param amount - amount of receipt token owner wants to redeem
@param owner - address of owner

*/
function withdraw(uint256 amount, address owner) public {
require(IERC20(receiptTokenAddress).balanceOf(owner) >= amount, "you don't have enough amount to redeem");
require(owner != address(0), "Invalid address");
uint256 userBalance = UserDetails[owner].amount;
uint256 initialTime = UserDetails[owner].dep_started;
uint256 reward = calculateReward(userBalance, initialTime);
UserDetails[owner].amount += reward;

if(amount == IERC20(receiptTokenAddress).balanceOf(owner)){
  UserDetails[owner].amount = 0; 
  UserDetails[owner].isDeposited = false;
  DAI.transferFrom(address(this), owner, UserDetails[owner].amount);
}
else{
uint256 amountToWithdraw = calculareShare(amount, owner);
UserDetails[owner].amount -= amountToWithdraw;
UserDetails[owner].dep_started = block.timestamp;
DAI.transferFrom(address(this), owner, amountToWithdraw);
}
IreceiptToken(receiptTokenAddress).burn(amount, owner);
}

/*
@notice - Function used to calculate rewards;
@param  - amount - the total DAI deposited at the time of reward calculation
@param - startTime - the time at which user deposited funds
*/
function calculateReward(uint256 amount, uint256 startTime) public view returns(uint256 reward){
   uint256 one_year = 365 * 24 * 60 * 60;
   uint256 endTime = block.timestamp;
   uint256 duration = endTime - startTime;
   uint256 rewardPercent = ((duration * 3) /100)/one_year;
   reward = amount * rewardPercent;

}
/*
@notice - Function used to convert the amount of receipt token to predefined token
@param share - the amount of receipt token to redeem
@param owner - address of the owner
*/
function calculareShare(uint256 share, address owner) public view returns (uint256){
   uint256 fullAmount = UserDetails[owner].amount;
   uint256 totalShare = IERC20(receiptTokenAddress).balanceOf(owner);
   uint256 amountToBeWithdrawed = (fullAmount * share)/totalShare;
    return amountToBeWithdrawed;
}
     
 }