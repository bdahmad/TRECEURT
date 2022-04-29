pragma solidity ^0.4.24;
import "./EmailRegex.sol";
import "./StringUtils.sol";

contract Accounts {
    address private owner;
    mapping(address => account) private accounts;
    address[] private verifiers;

    enum AccountType {
        Verifier,
        Requester
    }
    struct account {
        string name;
        string email;
        string logo;
        string description;
        AccountType aType;
        uint256 verificationPrice;
    }

    event Registered(address user);

    modifier isEmailValid(string _email) {
        require(EmailRegex.matches(_email));
        _;
    }

    modifier addVerifier(AccountType _aType) {
        _;
        if (_aType == AccountType.Verifier) {
            bool found = false;
            for (uint256 i = 0; i < verifiers.length; i++) {
                if (msg.sender == verifiers[i]) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                verifiers.push(msg.sender);
            }
        }
    }

    constructor() public {
        owner = msg.sender;
    }

    function register(
        string _name,
        string _email,
        string _logo,
        string _description,
        AccountType _aType,
        uint256 price
    ) public payable isEmailValid(_email) addVerifier(_aType) {
        emit Registered(msg.sender);
        accounts[msg.sender] = account({
            name: _name,
            email: _email,
            logo: _logo,
            description: _description,
            aType: _aType,
            verificationPrice: price
        });
    }

    function getAccount()
        public
        view
        returns (
            string name,
            string email,
            string logo,
            string description,
            AccountType aType,
            uint256 price
        )
    {
        name = accounts[msg.sender].name;
        email = accounts[msg.sender].email;
        logo = accounts[msg.sender].logo;
        description = accounts[msg.sender].description;
        aType = accounts[msg.sender].aType;
        price = accounts[msg.sender].verificationPrice;
        return (name, email, logo, description, aType, price);
    }

    function verifiersCount() public view returns (uint256 total) {
        return verifiers.length;
    }

    function getVerifier(uint256 pIndex)
        public
        view
        returns (
            address verifier,
            string name,
            string email,
            string logo,
            string description,
            AccountType aType,
            uint256 price
        )
    {
        address verifierAddr = verifiers[pIndex];
        name = accounts[verifierAddr].name;
        email = accounts[verifierAddr].email;
        logo = accounts[verifierAddr].logo;
        description = accounts[verifierAddr].description;
        aType = accounts[verifierAddr].aType;
        price = accounts[verifierAddr].verificationPrice;
        return (verifierAddr, name, email, logo, description, aType, price);
    }

    function getPrice(address _account) public view returns (uint256 price) {
        return (accounts[_account].verificationPrice);
    }

    function kill() public {
        if (msg.sender == owner) selfdestruct(owner);
    }
}
