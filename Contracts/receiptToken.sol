//SPDX-License-Identifier: Unlicense
 pragma solidity ^0.8.0;
 import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
 contract receiptToken is ERC20{

constructor() ERC20("Receipt token", "RT"){}
/*
@notice - is used to mint receipt token
*/
function mint(uint256 amount, address to) public {
    _mint(to, amount);

}
function burn(uint256 amount, address from) public {
    _burn(from, amount);
}


 }