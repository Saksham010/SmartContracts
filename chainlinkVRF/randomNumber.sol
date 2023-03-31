pragma solidity 0.8.18;

import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

contract RandomNumber is VRFV2WrapperConsumerBase{

    address linkAddress = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address wrapperAddress = 0x708701a1DfF4f478de54383E49a627eD4852C816;

    uint32 callbackGaslimit = 100000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;

    struct RequestStatus{
        uint256 paid;
        bool fulfilled;
        uint256[] randomWords;
        bool requested;
    }

    //Request id -> Status
    mapping(uint256 => RequestStatus) public idToRequest;
    
    uint256[] public requestIds;
    uint256 public lastRequestId;

    constructor() VRFV2WrapperConsumerBase(linkAddress,wrapperAddress){}

    // Request random number
    function requestRandomWord() external returns(uint256 requestId){
        uint256 requestId = requestRandomness(callbackGaslimit,requestConfirmations,numWords);
        idToRequest[requestId] = RequestStatus(VRF_V2_WRAPPER.calulateRequestPrice(callbackGaslimit),false,0,true);
        requestIds.push(requestId);
        lastRequestId = requestId;
        return requestId;
    }

    // Chainlink VRF -> fullfill
    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) internal override {
        require(idToRequest[_requestId].paid > 0, "request not found");
        idToRequest[_requestId].fulfilled = true;
        idToRequest[_requestId].randomWords = _randomWords;

    }

    // Check status of request
    function getRequestStatus(uint256 requestid) external view returns(uint256 paid,bool fulfilled, uint256[] memory randomWords){
        require(idToRequest[requestid].requested == true,"No request found");
        RequestStatus memory request = idToRequest[requestid];
        return(request.paid, request.fulfilled,request.randomWords);
    }

}pragma solidity 0.8.18;

import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

contract RandomNumber is VRFV2WrapperConsumerBase{

    address linkAddress = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address wrapperAddress = 0x708701a1DfF4f478de54383E49a627eD4852C816;

    uint32 callbackGaslimit = 100000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;

    struct RequestStatus{
        uint256 paid;
        bool fulfilled;
        uint256[] randomWords;
        bool requested;
    }

    //Request id -> Status
    mapping(uint256 => RequestStatus) public idToRequest;
    
    uint256[] public requestIds;
    uint256 public lastRequestId;

    constructor() VRFV2WrapperConsumerBase(linkAddress,wrapperAddress){}

    // Request random number
    function requestRandomWord() external returns(uint256 requestId){
        uint256 requestId = requestRandomness(callbackGaslimit,requestConfirmations,numWords);
        idToRequest[requestId] = RequestStatus(VRF_V2_WRAPPER.calulateRequestPrice(callbackGaslimit),false,0,true);
        requestIds.push(requestId);
        lastRequestId = requestId;
        return requestId;
    }

    // Chainlink VRF -> fullfill
    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) internal override {
        require(idToRequest[_requestId].paid > 0, "request not found");
        idToRequest[_requestId].fulfilled = true;
        idToRequest[_requestId].randomWords = _randomWords;

    }

    // Check status of request
    function getRequestStatus(uint256 requestid) external view returns(uint256 paid,bool fulfilled, uint256[] memory randomWords){
        require(idToRequest[requestid].requested == true,"No request found");
        RequestStatus memory request = idToRequest[requestid];
        return(request.paid, request.fulfilled,request.randomWords);
    }

}