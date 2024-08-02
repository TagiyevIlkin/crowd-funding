// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding{

    // Declaring state variables
    mapping (address=>uint) public contributors;
    address public admin;
    uint public noOfContributors;
    uint public minimumContribution;
    uint public  deadline; // timestamp
    uint public goal;
    uint public totalRaisedAmount;

    // Declare request struct
    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }

    // To store all the spending request
    mapping(uint=>Request) public requests;

    uint public  numRequests;

    // Initialize the constructor
    constructor(uint _goal,uint _deadline) {
        goal=_goal;
        deadline=block.timestamp+_deadline; // deadline in seconds
        minimumContribution=100;
        admin=msg.sender;
    }
  
    // Declare events
    event ContributeEvent(address _sender, uint _value);
    event CreateRequest(string _description,address _recipient, uint _value);
    event Makepayment(address _sender, uint _value);

    // contribute allows users to contribute the funding
    function contribute() public payable {
        // Check the conditions if they met
        require(block.timestamp<deadline,"Deadline has passed");
        require(msg.value>=minimumContribution,"Minimum contribution amount not met");

        // If the sender contributes first time then increase the noOfContributors
        if(contributors[msg.sender]==0){
            noOfContributors++;
        }

        // Add the contribution 
        contributors[msg.sender]+=msg.value;
        // Add the contribution to totalRaisedAmount
        totalRaisedAmount+=msg.value;
        emit ContributeEvent(msg.sender, msg.value);
    }

    // contribute function is usually applies from frontend and they just send ether directly to contract address
    // In order to accept ether, so built-in receive function shoulb be applied
    receive() external  payable {
        contribute();
    }

    // getBalance returns the current balance of the contract
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    // getRefund refunds the money back to contributors if deadline has passed and goal has not reached.
    function getRefund() public     {
        require(block.timestamp>deadline && totalRaisedAmount<goal,"Cannot refund");
        require(contributors[msg.sender]>0,"Already refunded");

        address payable recipient=payable (msg.sender);
        uint amount = contributors[msg.sender];
        // Reset the contribute of recipient to 0
        contributors[recipient]=0;
        // Transfer amount to recipient
        recipient.transfer(amount);
        
    }

    // onlyAdmin requires user to be admin
    modifier onlyAdmin() {
        require(msg.sender==admin,"Only admin is allowed");
        _;
    }

    // createRequest creates a new request than contributors can vote for it
    function createRequest(string memory _description,address payable _recipient,uint _value)public onlyAdmin {
        // Create a new storage instance of Request
        Request storage newRequest=requests[numRequests];
        // Increase the numRequests
        numRequests++;

        newRequest.description=_description;
        newRequest.recipient=_recipient;
        newRequest.value=_value;
        newRequest.completed=false;
        newRequest.noOfVoters=0;

        emit CreateRequest(_description, _recipient, _value);
    }

    // onlyContributor requires user to be a contributor
    modifier onlyContributor() {
        require(contributors[msg.sender]>0,"Only contributor is allowed");
        _;
    }
    // voteRequest allows the contributor to vote for the request
    function voteRequest(uint _requestNo)public onlyContributor{
        // Get the request
        Request storage thisRequest=requests[_requestNo];
        require(thisRequest.voters[msg.sender]==false,"You have already voted");
        thisRequest.voters[msg.sender]==true;
        thisRequest.noOfVoters++;

    }

    function makePayment(uint _requestNo) public onlyAdmin{
       // Make sure totalRaisedAmount is greater than goal
        require(totalRaisedAmount>=goal,"The goal has not met");
        Request storage thisRequest=requests[_requestNo];
        // Make sure the request has not been completed
        require(thisRequest.completed==false,"The reuested has been completed!");
        // Make sure at least more than 50 % of contributers voted
        require(thisRequest.noOfVoters>noOfContributors/2,"At least more than 50 % of contributers should vote to proceed payment");
        // Transfer the value to recipient
        thisRequest.recipient.transfer(thisRequest.value);
        // Complete the request
        thisRequest.completed=true;

       emit Makepayment(thisRequest.recipient, thisRequest.value);
    }

}