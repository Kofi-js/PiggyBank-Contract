// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PiggyBank {

    address public constant DEVELOPER = 0x812A02c580ed6aC018856514bE2D8DBD3633CD4b; // my address asper developer
    // confused if i should have seperate addresses for seperate tokens or not.

    // state variables
    address public immutable owner;
    uint256 public immutable savingDuration;
    uint256 public immutable startTime;
    string public reason;
    bool public withdrawn;


    // required token addresses
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    // address[] public allowedTokens = [USDC, USDT, DAI];
    
    //to track token balances
    mapping(address => mapping(address => uint256)) public tokenBalances;
    // mapping(address => bool) public isAllowedToken;
    // mapping(address => uint256) public tokenBalances;
    

    //events
    event Deposited(address indexed token, uint256 amount);
    event Withdrawn(address indexed token, uint256 amount);
    event EmergencyWithdrawn(address indexed token, uint256 received, uint256 penalty);
    


    //modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier notWithdrawn() {
        require(!withdrawn, "Already withdrawn");
        _;
    }
    
    modifier durationCheck() {
        require(block.timestamp >= startTime + savingDuration, "Too early");
        _;
    }

    constructor(address _owner, uint256 _duration, string memory _reason) {
        owner = _owner;
        savingDuration = _duration;
        reason = _reason;
        startTime = block.timestamp;
    }

    function _isAllowedToken(address _token) private pure returns (bool) {
        return _token == USDC || _token == USDT || _token == DAI;

    }

    function deposit(address _token, uint256 _amount) external onlyOwner notWithdrawn {
        require(_isAllowedToken(_token), "Invalid token");
        require(_amount > 0, "Invalid amount");

        bool success = IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        require(success, "Transfer failed");

        tokenBalances[msg.sender][_token] += _amount;
        emit Deposited(_token, _amount);
    }

    function withdraw() external onlyOwner notWithdrawn durationCheck  {
        withdrawn = true;
        
        _transferTokens(false);
    }

    function emergencyWithdraw() external onlyOwner notWithdrawn {
        withdrawn = true;
        _transferTokens(true);
    }

    function _transferTokens(bool isEmergency) private {
    address[3] memory tokens = [USDC, USDT, DAI];
    
    uint256 totalAmountToTransfer = 0; // Variable to hold total amount to transfer

    // Declare an array to store balances for all tokens
    uint256[3] memory balances;

    // Fetch balances for each token in one go
    for (uint i = 0; i < tokens.length; i++) {
        balances[i] = tokenBalances[msg.sender][tokens[i]];
    }

    // Loop through each token and process withdrawals
    for (uint i = 0; i < tokens.length; i++) {
        address token = tokens[i];
        uint256 balance = balances[i]; // Use pre-fetched balance from the array
        if (balance == 0) continue; // Skip if there's no balance to withdraw

        // Add to the total amount to be transferred
        totalAmountToTransfer += balance;

        // Reset the balance of the user for the token
        tokenBalances[msg.sender][token] = 0;

        // Emergency withdrawal logic (penalty applied)
        if (isEmergency) {
            uint256 penalty = balance * 15 / 100;
            uint256 remaining = balance - penalty;
            
            // Transfer remaining balance to owner
            IERC20(token).transfer(owner, remaining);
            // Transfer penalty to developer
            IERC20(token).transfer(DEVELOPER, penalty);

            // Emit event for emergency withdrawal
            emit EmergencyWithdrawn(token, remaining, penalty);
        } else {
            //Transfer full balance to the user
            IERC20(token).transfer(msg.sender, balance);
            // Emit event for regular withdrawal
            emit Withdrawn(token, balance);
        }
    }
    
    }

}