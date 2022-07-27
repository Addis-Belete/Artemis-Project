//SPDX-License-Identifier: Unlicense
 pragma solidity ^0.8.0;
 contract receiptToken {
/*
@notice - is used to mint receipt token
*/
string name = "Receipt Token";
string symbol = "RT";
mapping(address => uint256) balance;

function mint(uint256 amount, address to) public {
    require(to != address(0), "invalid address");
    uint256 am = amount * 10e18;
    balance[to] += am;

}

function burn(uint256 amount, address from) public {
    require(balance[from] >= amount, "you don't have enough amount to burn");
    uint256 am = amount * 10e18;
    balance[from]-= am;
}

function balanceOf(address owner) public view returns(uint256 _balance){
    _balance = balance[owner];
}
 }