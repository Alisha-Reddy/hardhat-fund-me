// SPDX-License-Modifier:MIT

// 1. Pragma
pragma solidity ^0.8.0;
// 2. Imports
import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

// 3. Interfaces, Libraries, Contracts

/**@title A contract for crowd funding
 *@notice This contract is to demo a sample funding contract
 */

contract FundMe {

    // Type declaration
    using PriceConverter for uint256;

    // State variable
    AggregatorV3Interface public priceFeed;
    uint256 public constant MINIMUM_USD = 50 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    address public immutable i_owner;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        // We want to set a minimum fund amount in USD
        // payable sets the function as payable and marks it in red color
        // require(msg.value > 1e18, "Didn't send enough!"); //This is for the person who require msg value more than 1e18
        // 1e18 == 1 * 10 ** 18 == 10 to the power 18 = 1000000000000000000 wei = 1 Eth
        // The second part in the above line is revert

        require(
            msg.value.getConversionRate(priceFeed) > MINIMUM_USD,
            "Didn't send enough!"
        );
        funders.push(msg.sender); // msg.sender is the address of the sender that's calling the contract
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // We need to rest the array
        funders = new address[](0);

        // And also withdraw the amount

        // // transfer
        // payable(msg.sender).transfer(address(this).balance); //msg.sender is address type which makes payable(msg.sender) makes it a payable address

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");

        // call
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner,"Sender is not owner");
        if (msg.sender != i_owner) {
            revert("U r not the owner!!!");
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
