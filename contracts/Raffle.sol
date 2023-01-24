// Raffle

// Enter the lottery (paying some amount)
// Pick a random winner (veifiably random)
// Winner to be selected every X minutes -> completly automated
// Chainlink Oracle -> Randomness, Automated Execution (Chainlink Keeper)

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

error Raffle__NotEnoghETHEntered();

contract Raffle is VRFConsumerBaseV2{

    /* State variables */
    uint256 private immutable i_entraceFee;
    address payable[] private s_players;

    /* Events */
    event RaffleEnter(address indexed player);

    constructor(address vrfCoordinatorv2, uint256 entranceFee) VRFConsumerBaseV2(vrfCoordinatorv2){
        i_entraceFee = entranceFee;
    }

    function enterRaffle() public payable {
        // require msg.value > i_entranceFee, "not enough ETH"
        if(msg.value <= i_entraceFee){
            revert Raffle__NotEnoghETHEntered();
        }

        s_players.push(payable(msg.sender));
        emit RaffleEnter(msg.sender);
        //Emit an event when we update a dynamic 

    }

    function requestRadomWinner() external {
        // Request the random number
        // Once we gert it, do something with it
        // 2 transaction process
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) 
    internal override {

    }

    function getEntranceFee() public view returns(uint256){
        return i_entraceFee;
    }

    function getPlayer(uint256 index) public view returns(address){
        return s_players[index];
    }
}