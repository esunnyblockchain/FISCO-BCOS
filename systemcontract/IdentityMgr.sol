pragma solidity ^0.4.4;

contract IdentityMgr {

    struct IdentityInfo {
        string name; // name
        string id; // id card no
        uint256 blocknumber;  //block number
        uint256 timestamp; // time
    }

    mapping(address=>IdentityInfo) private _identity_info;
    mapping(address=>bool) private _identity_valid;
    address[] _reg_accounts;
    address[] _valid_accounts;

    event Identity(address indexed account, string name, string id, uint256 blocknumber);
    event IdentityReg(address account, string name, string id, uint256 blocknumber);

    function setIdentityInfo(string name, string id) public {
        _identity_info[msg.sender] = IdentityInfo(name, id, block.number, block.timestamp);
        if (_identity_valid[msg.sender]) {
            removeAccount(_valid_accounts, msg.sender);
        }
        _identity_valid[msg.sender] = false;
        insertAccount(_reg_accounts, msg.sender);

        IdentityReg(msg.sender, name, id, block.number);
    }

    function agreeIdentityInfo(address account) public {
        _identity_valid[account] = true;

        removeAccount(_reg_accounts, account);
        insertAccount(_valid_accounts, account);

        IdentityInfo storage info = _identity_info[account];
        Identity(account, info.name, info.id, info.blocknumber);
    }

    function removeAccount(address[] storage accounts, address account) private {
        for (uint256 i = 0; i < accounts.length; ++i) {
            if (accounts[i] == account)
                delete accounts[i];
        }
    }

    function insertAccount(address[] storage accounts, address account) private {
        bool isSaved = false;
        for (uint256 i = 0; i < accounts.length; ++i) {
            if (accounts[i] == 0x0000000000000000000000000000000000000000) {
                accounts[i] = account;
                isSaved = true;
                break;
            }
        }
        if (!isSaved)
            accounts.push(account);
    }

    function getIdentityInfo(address account) public constant returns (string, string, uint256)  {
        IdentityInfo storage info = _identity_info[account];
        return (info.name, info.id, info.blocknumber);
    }

    function getIdentityProof() public {
        if (!_identity_valid[msg.sender])
            return;
        IdentityInfo storage info = _identity_info[msg.sender];
        Identity(msg.sender, info.name, info.id, info.blocknumber);
    }

    function getRegAccounts() constant public returns (address[]) {
        return _reg_accounts;
    }

    function getValidAccounts() constant public returns (address[]) {
        return _valid_accounts;
    }
}

