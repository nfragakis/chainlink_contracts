// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract APIConsumer is ChainlinkClient {
    using Chainlink for Chainlink.Request;
  
    uint256 public rainfall;
    
    address public oracle;
    bytes32 public jobId;
    uint256 public fee;
    
    constructor() {
        setPublicChainlinkToken();
        oracle = 0x3Aa5ebB10DC797CAC828524e59A333d0A371443c;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    }
    
    function requestRainfall() external {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        request.add("get", "http://rainfall-oracle.com/");
       request.add("path", "rainfalls.iowa.september.2021.average");

        sendChainlinkRequestTo(oracle, request, fee);
    }
    
    function fulfill(bytes32 _requestId, uint256 _rainfall) public recordChainlinkFulfillment(_requestId) {
        rainfall = _rainfall;
    }
} 
