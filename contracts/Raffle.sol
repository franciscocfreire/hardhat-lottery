// Raffle

// Enter the lottery (paying some amount)
// Pick a random winner (veifiably random)
// Winner to be selected every X minutes -> completly automated
// Chainlink Oracle -> Randomness, Automated Execution (Chainlink Keeper)

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

error Raffle__NotEnoghETHEntered();

contract Raffle{

    /*State variables */abi
    uint256 private immutable i_entraceFee;
    address payable[] private s_players;

    constructor(uint256 entranceFee){
        i_entraceFee = entranceFee;
    }

    function enterRaffle() public payable {
        // require msg.value > i_entranceFee, "not enough ETH"
        if(msg.value <= entranceFee){
            revert Raffle__NotEnoghETHEntered();
        }

        s_players.push(payable(msg.sender))

    }

    // function pickRadomWinner(){}

    function getEntranceFee() public view returns(int256){
        return i_entraceFee;
    }

    function getPlayer(uint256 index) public biew returns(address){
        return s_players[index]
    }
}