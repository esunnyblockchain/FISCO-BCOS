pragma solidity ^0.4.10;

import "./standard/ERC165.sol";

contract CheckERC165 is ERC165 {
    mapping (bytes4 => bool) internal supportedInterfaces;

    function CheckERC165() public {
        supportedInterfaces[bytes4(keccak256("supportsInterface(bytes4)"))] = true;
    }
    
    /// @notice Query if a contract implements an interface
    /// @param interfaceID The interface identifier, as specified in ERC-165
    /// @dev Interface identification is specified in ERC-165. This function
    ///  uses less than 30,000 gas.
    /// @return `true` if the contract implements `interfaceID` and
    ///  `interfaceID` is not 0xffffffff, `false` otherwise
    function supportsInterface(bytes4 interfaceID) external constant returns (bool){
        return supportedInterfaces[interfaceID];
    }
}
