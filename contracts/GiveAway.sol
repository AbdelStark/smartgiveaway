// contracts/GiveAway.sol
// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.6.0 <0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
interface IPOSDAORandom {
    function collectRoundLength() external view returns(uint256);
    function currentSeed() external view returns(uint256);
    function nextCommitPhaseStartBlock() external view returns(uint256);
    function nextRevealPhaseStartBlock() external view returns(uint256);
}
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
    mapping(uint256 => uint256) public participantsScores;
    string public _tweetLink;
    uint256 public winnerIndex;
    IPOSDAORandom private _posdaoRandomContract; // address of RandomAuRa contract
    modifier onlyRegisteredUser()
    {
        require(keccak256(_participants[msg.sender].id) != keccak256(bytes("")), "You need to validate your participation");
        _;
    }
    constructor (IPOSDAORandom randomContract, string memory name, string memory tweetLink, uint256 maxParticipants, uint256 scoreRetweet, uint256 scoreLike) public payable {
        require(msg.value>0);
        require(randomContract != IPOSDAORandom(0));
        _posdaoRandomContract = randomContract;
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
    function close() public payable onlyOwner whenNotPaused {
        uint256 seed = _posdaoRandomContract.currentSeed();
        uint256 scoreWinner = 0;
        for (uint i = 0; i < _listParticipants.length; i++) {
            uint currentScore = getScore(_listParticipants[i]);
            participantsScores[i] = currentScore;
            if(currentScore >= scoreWinner){
                scoreWinner = currentScore;
            }
        }
        uint256[] storage winnersCandidates;
        for (uint i = 0; i < _listParticipants.length; i++) {
            if(participantsScores[i]==scoreWinner){
                winnersCandidates.push(i);
            }
        }
        winnerIndex = winnersCandidates[seed%winnersCandidates.length];
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
    function getSeedForCurrentPhase() public view returns (uint256){
        return _posdaoRandomContract.currentSeed();
    }
    function getSeedModuloX(uint x) public view returns (uint256){
        uint256 seed = _posdaoRandomContract.currentSeed();
        return seed % x;
    }
    function getNextCommitPhaseStartBlock() public view returns(uint256){
        return _posdaoRandomContract.nextCommitPhaseStartBlock();
    }
    function getNextRevealPhaseStartBlock() public view returns(uint256){
        return _posdaoRandomContract.nextRevealPhaseStartBlock();
    }
}
