// Raffle

// Enter the lottery (paying some amount)
// Pick a random winner (veifiably random)
// Winner to be selected every X minutes -> completly automated
// Chainlink Oracle -> Randomness, Automated Execution (Chainlink Keeper)

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";



error Raffle__NotEnoghETHEntered();
error Raffle__TransferFailed();

contract Raffle is VRFConsumerBaseV2, KeeperCompatibleInterface{

    /* State variables */
    uint256 private immutable i_entraceFee;
    address payable[] private s_players;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    uint16 private constant REQUEST_CONFIMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    address private s_recentWinner;

    /* Events */
    event RaffleEnter(address indexed player);
    event RequestRaffleWinnter(uint256 indexed requestId);
    event WinnerPicked(address indexed winner);

    constructor(
        address vrfCoordinatorv2, 
        uint256 entranceFee,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
        ) VRFConsumerBaseV2(vrfCoordinatorv2){
        i_entraceFee = entranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorv2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
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

    /**
     * @dev This is the function that the Chainlink Keeper nodes call
     * they look for the `upKeepNeeded` to return true
     * The following should be true in order to return true:
     * 1. Our time interval should havev passed
     * 2. The lottery should have at least 1 player, and have some ETH
     * 3. Our subscription is funded with LINK
     * 4. The lottery should be in an "open" state;
     */
    function checkUpkeep(bytes calldata) external override {

    }

    function requestRadomWinner() external {
        // Request the random number
        // Once we gert it, do something with it
        // 2 transaction process

        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );

        emit RequestRaffleWinnter(requestId);
    }

    function fulfillRandomWords(uint256, uint256[] memory randomWords) 
    internal 
    override 
    {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        (bool success,) = recentWinner.call{value: address(this).balance}("");
        if(!success){
            revert Raffle__TransferFailed();
        }

        emit WinnerPicked(recentWinner);
    }

    function getEntranceFee() public view returns(uint256){
        return i_entraceFee;
    }

    function getPlayer(uint256 index) public view returns(address){
        return s_players[index];
    }

    function getRecentWinner() public view returns(address){
        return s_recentWinner;
    }
}