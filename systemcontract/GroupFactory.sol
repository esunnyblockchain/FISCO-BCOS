pragma solidity ^0.4.4;

import "Group.sol";

contract GroupFactory {

    address[] private _groups;

    function GroupFactory() public {
        _groups.push(new Group());
    }

    function newGroup() public returns(address) {
        address group = new Group();
        _groups.push(group);
        return group;
    }

    function getBaseGroup() public constant returns(address) {
        return _groups[0];
    }

    function getAllGroups() public constant returns(address[]) {
        return _groups;
    }

    function getGroup(uint256 index) public constant returns(address) {
        return _groups[index];
    }
}
