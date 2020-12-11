// contracts/GiveAway.sol
// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract GiveAway is Ownable, Pausable{

    uint public constant RETWEET_INDEX = 0;

    uint public constant LIKE_INDEX = 1;

    struct Rules {
        uint256 scoreRetweet;
        uint256 scoreLike;
    }

    struct Participant {
        bytes id;
        uint[2] status;
    }

    string public _name;
    uint256 public _maxParticipants;
    Rules public _rules;


    address [] _listParticipants;
    mapping(address => Participant) public _participants;
    string public _tweetLink;
    uint public winnerIndex;

    modifier onlyRegisteredUser()
    {
        require(keccak256(_participants[msg.sender].id) != keccak256(bytes("")), "You need to validate your participation");
        _;
    }


    constructor (string memory name, string memory tweetLink, uint256 maxParticipants, uint256 scoreRetweet, uint256 scoreLike) public payable {
        require(msg.value>0);
        _maxParticipants = maxParticipants;
        _name = name;
        _rules = Rules(scoreRetweet, scoreLike);
        _tweetLink = tweetLink;
    }

    function participate(string memory id) public payable whenNotPaused{
        require(_listParticipants.length < _maxParticipants, "The maximum number of participants is reached");
        require(keccak256(_participants[msg.sender].id) == keccak256(bytes("")), "You have already validated your participation");
        _listParticipants.push(msg.sender);
        _participants[msg.sender].id = bytes(id) ;
    }

    function retweet() public payable onlyRegisteredUser whenNotPaused{
        require(_participants[msg.sender].status[RETWEET_INDEX] == 0, "You can only retweet once");
        _participants[msg.sender].status[RETWEET_INDEX] = 1;
    }

    function like() public payable onlyRegisteredUser whenNotPaused {
        require(_participants[msg.sender].status[LIKE_INDEX] == 0, "You can only like once");
        _participants[msg.sender].status[LIKE_INDEX] = 1;

    }

    function getMyScore() public view returns (uint256) {
        return getScore(msg.sender);
    }

    function getScore(address participant) public view returns (uint256) {
        return _participants[participant].status[RETWEET_INDEX] * _rules.scoreRetweet
        + _participants[participant].status[LIKE_INDEX] * _rules.scoreLike;

    }

    function isUserParticipating(address participant) public view returns (bool){
        return keccak256(_participants[participant].id) != keccak256(bytes(""));
    }

    function amIParticipating() public view returns (bool){
        return isUserParticipating(msg.sender);
    }

    function numberOfParticipants() public view returns (uint256){
        return _listParticipants.length;
    }

    function close() public payable onlyOwner whenNotPaused{
        if(numberOfParticipants()>0){
            uint winnerFound;
            uint scoreWinner = 0;
            for (uint i = 0; i < _listParticipants.length; i++) {
                uint currentScore = getScore(_listParticipants[i]);
                if(currentScore > scoreWinner){
                    winnerFound = i;
                    scoreWinner = currentScore;
                }
            }
            winnerIndex = winnerFound;
        }
        _pause();
    }

    function getWinnerId() public view whenPaused returns(string memory){
        require(numberOfParticipants()>0, "No found participant");
        return string(_participants[_listParticipants[winnerIndex]].id);
    }

    function getWinnerAddress() public view whenPaused returns(address){
        require(numberOfParticipants()>0, "No found participant");
        return _listParticipants[winnerIndex];
    }
}
