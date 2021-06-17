pragma solidity 0.8.4;

contract Motivate {

    struct Database{
      address userAddress;
      string name;
      string friendName;
      address payable friendAddress;
      uint256 DeadlineDate;
      string task;
      uint id;
      uint amount;
    }
    uint counter=0;
    Database[] public table;
    address public smartContractAddress;

    constructor() payable{
      smartContractAddress=msg.sender;
    }

    function createPromise( string memory _name, address payable _friendAddress, string memory _friendName, uint256 _DeadlineDate, uint _amount, string memory _task) public returns(uint _hash){
      //update Database, update user, send token to smart contract
      //require that user has funds
      require(msg.sender.balance>=_amount);
      counter=counter+1;
      table.push(Database(msg.sender, _name, _friendName, _friendAddress, _DeadlineDate, _task, counter, _amount));

      payable(smartContractAddress).transfer(_amount);

      return counter;
      }

    function listMyPromises() public returns(address[] memory ){ //lists all my past promises
       uint count=0;
       for(uint i=0; i<table.length; i++){
        if(table[i].userAddress==msg.sender){
            count++;
        }
       }
      address[] memory List = new address[](count);

      uint counter1=0;
       for(uint i=0; i<table.length; i++){
        if(table[i].userAddress==msg.sender){
          List[counter1]=((table[i].friendAddress));
          counter1++;
        }
      }
        return List;
    }

    function validatePromise(address payable _taskCreator, bool completed, uint _hash) public payable {
      //require( address is in the pendingtrans)

      //transfer money back to user or recieve money if task not completed
      //require deadline hasn't passed
      for(uint i=0; i<table.length; i++){
        if(table[i].userAddress==_taskCreator && table[i].id ==_hash){
          if (completed==false){
            payable(msg.sender).transfer(table[i].amount);
          }else{
            (_taskCreator).transfer(table[i].amount);
          }
        }



    }
}
}
