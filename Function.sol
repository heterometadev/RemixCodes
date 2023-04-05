 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract FunctionsExample {

    mapping(address => uint) balanceReceived;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    //view function can only read storage variables;
    //You can not call another writing function
    function getOwner() public view returns(address) {
        return owner;
    }

    //pure functions mean this function does not interact with storage variables
    //balanceReceived ,owner etc.
    function convertWeiToEther(uint _amountInWei) public pure returns(uint){
        return _amountInWei / 1 ether;
    }

    function receiveMoney() public payable {
        assert(balanceReceived[msg.sender] + msg.value >= balanceReceived[msg.sender]);
        balanceReceived[msg.sender] += msg.value;
    }

    function withdrawMoney(address payable _to,uint _amount) public {
        require(_amount <= balanceReceived[msg.sender] , "Not enough funds");
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }


}
