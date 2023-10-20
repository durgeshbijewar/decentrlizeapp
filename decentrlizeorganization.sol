//SPDX-LICENSE-Identifier: MIT

pragma solidity ^0.8.13;

contract DAQ {

    //variables
    address public owner;
    mapping(address => uint) public members;
    uint public totalshares;
    uint vottingperiods = 7 days;

    //events
    event memberadded(address member);
    event memberremoved(address memebr);
    event sharesbought(address buyer , uint amount);
    event shareshold(address seller , uint amount);
    event proposalsubmitted(address proposer , string propasal);
    event voted(address voter, uint proposalid, bool infavor);
    event proposalexecuted(address executer , uint proposalid);

    //structs
    struct proposal {
        address proposer;
        string description;
        uint votesfor;
        uint votesagainst;
        bool executed;
        bool isapproved;
        mapping(address => bool)hasvoted;
    }

    //mapping method
    mapping(uint => proposal) proposals;
    uint proposalid;
    

    //modifiers
    modifier onlyowner() {
        require(msg.sender == owner, "only the owner can callthis function");
        _;
    }

    modifier onlymember() {
        require(members[msg.sender], "only members can call this function");
        _
    
    }

    //contructer
    constructor() {
        owner = msg.sender;
        members[msg.sender] = true;
        totalshares = 100;
        shares[msg.sender] = 100;
    }

    //function
    function addmembers(address _member) public onlyowner {
        require(!members[_member], "member alredy exists");
        members[_member] = true;
        totalshare++;
        shares[_member] = 1;
        emit memberadded(_member);
    }

    function removemember(address _member) public onlyowner {
        require(members[_member], "member does not exist");
        require(_member != owner, "cannot remove owner");
        members[_member] = false;
        totalshares--;
        shares[_member] = 0;
        emit memberremoved(_member);
    }

    function buyshares(uint _amount) public payable onlymember {
        require(_amount <= (totalshares - shares[msg.sender]), "not enough shares available");

        uint cost = _amount * 1 ether;
        require(msg.value == cost , "incorrect value sent");

        shares[msg.sender] += _amount;
        totalshares += _amount;
        emit sharebought(msg.sender, _amount);
    }

    function sellshare(uint _amount) public onlymember {
        require(shares[msg.sender] >= _amount,"not enough shares owned");

        shares[msg.sender] -= _amount;
        totalshare -= _amount;

        payable(msg.sender).transfer(_amount * 1 ether);
        emit sharesold(msg.sender, _amount);
    }

    function submitpropsal(string memory _description) public onlymember{
        propasalid++;
        propasal storage propasal = propasals[propasalid];
        propasal.proposer = msg.sender;
        propasal.description = _description;
        propasal.votesfor = 0;
        propasal.votesagainst = 0;
        propasal.executed = false;
        propasal.hasvoted[msg.sender] = false;
        emit propasalsubmitted(msg.sender, _description);
    }

    //nice functionality
    function vote(uint _proposalid, bool _infavor) public onlymember {
        proposal storage proposal = proposals{}

        if(_infavor) {
            proposal.votesagainst += shares[msg.sender];
        }
        else {
            propasal.votesagainst += shares[msg.sender];
        }

        prpposal.hasvoted[msg.sender] = true;
        emit voted(msg.sender, _proposaid, _infavor);

    }

    function executedpropasal(uint _proposalid) public onlymember {
        proposal storage proposal = proposals[_proposalid];
        require(!propasal.executed, "proposal alredy executed");
        require(block.timestamp > votingperiod, "votiong period has not expired");

        if(proposal.votesfor > proposal.votesagainst){
            propasal.executed = true;
            propasal.isapproved = true;

            emit proposalexecuted(msg.sender, _proposalid);
        }
        else if(propasal.votesagainst > propasal.votefor) {
            proposal.executed = true;
            propasal.isapproved = false;
            emit proposal.executed = false;
        }
    }


}