pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

contract Capsule is KeeperCompatibleInterface {
    address payable recipient;
    uint lockedUntil;

    function deposit(uint _lockedUntil) external payable {
        require(lockedUntil == 0);
        lockedUntil = _lockedUntil;
        recipient = payable(msg.sender);
    }

    function checkUpkeep(bytes calldata) external view override returns (bool, bytes memory) {
        bool upKeepNeeded = lockedUntil > 0 && block.timestamp > lockedUntil;
        return (upKeepNeeded, "0x");
    }

    function performUpkeep(bytes calldata) external override {
        require(block.timestamp > lockedUntil);
        recipient.transfer(address(this).balance);
        delete lockedUntil;
    }   
}