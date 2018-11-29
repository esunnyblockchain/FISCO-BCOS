pragma solidity ^0.4.11;
import "./LibArray.sol";
contract UserContractMgr
{
    string[] contractNames;
    event log(string);

    function addContractName(string contractName) 
    {   
        uint256 length = contractNames.length;
        for(uint256 i = 0; i < length; ++i)
        {
            if(LibString.equals(contractName, contractNames[i]))
            {
                log("Add a exist contract");
                return;
            }
        }
        contractNames.push(contractName); 
        log("Add contract success");
    }   

    function delContractName(string contractName) returns (bool)
    {   
        LibArray.deleteElement(contractNames, contractName);
        return true;
    }   

    function getSize() returns (uint256)
    {   
        return contractNames.length;
    }   

    function getContractNameByIndex(uint256 i) returns (string)
    {   
        return contractNames[i];
    }   
}
