pragma solidity ^0.4.17;

contract Lottery{
    // Type Visibility(public or private) Name
    address public manager; 

    // Dynamic array that will hold the addresses of those that have entered
    address[] public players;

    // Constructor Function
    function Lottery() public{
        // Global variable that has the address of who created the contract
        manager = msg.sender;
    }

    // Function that allows someone to enter the lottery
    function enter() public payable{
        // Statement that makes sure whoever enters the lottery is submitting .01 eth to enter
        require(msg.value > .01 ether);
        
        // Take the function caller's address and store it in the address array
        players.push(msg.sender);
    }

    // Function that selects random winner
    // Since the function is private we won't be able to call it
    function random() private view returns (uint){
        return uint(keccak256(block.difficulty, now, players));
    }

    // Function that calls the private function above to get the random winner
    function pickWinner() public restricted{
        // Making sure no one can call this function except the manager
        //require(msg.sender == manager);

        // Getting the winner for the lottery
        uint index = random() % players.length;

        // Finding winner in our array. Getting the address
        players[index].transfer(this.balance);

        // Making players a new dynamic array that starts off with size zero
        players = new address[](0);
    }

    // Function modifier that makes sure the call of the function is the manager
    // Check pickWiner()
    modifier restricted() {
        require(msg.sender == manager);
        _; // Takes code from function with modifer and places it here
    }

    // Function to get a list of all the palyers
    // Everyone will have access to this function and
    // it'll return a list of all the address in the lottery 
    function getPlayers() public view returns (address[]){
        return players;
    }

}   