// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Owned {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

        modifier onlyOwner() {
         require(msg.sender == owner , "You are not the owner");
         _;
    }
    
}

contract InheritanceModifierExample is Owned {
    mapping(address => uint256) public tokenBalance;



    uint256 tokenPrice = 1 ether;

    constructor() public {
        tokenBalance[owner] = 100;
    }



    function createNewToken() public  onlyOwner{
        tokenBalance[owner]++;
    }

    function burnToken() public onlyOwner {
          tokenBalance[owner]--;
    }

    function sendToken(address _to , uint _amount) public {
        require(tokenBalance[msg.sender] >= _amount, "Not enough tokens");
        assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
        assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);

    }
}
