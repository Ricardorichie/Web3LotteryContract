pragma solidity ^0.4.17;

contract Lottery{
    address public manager;
    address[] public players;

    // constructor
    function Lottery() public{
        manager = msg.sender; // msg is a global variable
    }

    //function modifier... used to implement DRY  
    modifier restricted(){
    require(msg.sender == manager);
    _;} 

    function enter() public payable{
        require(msg.value>0.01 ether);
        players.push(msg.sender);
    }

    function random() private view returns (uint){
        return uint(keccak256(block.difficulty,now,players)); //hashing to give randomness
    }

    //restricted here is a modifier created above 
    function pickWinner() public restricted{
        uint index = random() % players.length;
        //to send all the money in the contract to the address
        players[index].transfer(this.balance);
        players = new address[](0);
    }

    function getPlayers() public view returns (address[]) {
        return players;
    }
}