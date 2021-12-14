pragma solidity =0.6.6;

import '@uniswap/lib/contracts/libraries/TransferHelper.sol';
import './libraries/SafeMath.sol';
import './interfaces/IWETH.sol';

contract UniswapV2AdminFee {
    using SafeMath for uint;

    address public WETHs;
    address public adminAddress;
    address public feeAddress;
    uint    public swapFee;
    uint    public addLiquidityFee;
    uint    public removeLiquidityFee;

    function setAdminAddress(address _adminAddress) external {
        require(msg.sender == adminAddress, 'UniswapV2: FORBIDDEN');
        adminAddress = _adminAddress;
    }

    function setFeeAddress(address _feeAddress) external {
        require(msg.sender == adminAddress, 'UniswapV2: FORBIDDEN');
        feeAddress = _feeAddress;
    }

    function setSwapFee(uint _swapFee) external {
        require(msg.sender == adminAddress, 'UniswapV2: FORBIDDEN');
        swapFee = _swapFee;
    }

    function setAddLiquidityFee(uint _addLiquidityFee) external {
        require(msg.sender == adminAddress, 'UniswapV2: FORBIDDEN');
        addLiquidityFee = _addLiquidityFee;
    }

    function setRemoveLiquidityFee(uint _removeLiquidityFee) external {
        require(msg.sender == adminAddress, 'UniswapV2: FORBIDDEN');
        removeLiquidityFee = _removeLiquidityFee;
    }

    function _swapFeeWork(uint[] memory amounts, address token) internal virtual returns (uint[] memory amountberk) {
        uint[] memory amountberk= amounts;
        if(swapFee > 0 && address(feeAddress) != address(0)){
            uint feeAmountTarget = amounts[0];
            feeAmountTarget = feeAmountTarget.mul(swapFee).div(10000).add(1);
            TransferHelper.safeTransferFrom(
                token, msg.sender,feeAddress ,feeAmountTarget
            );
            amountberk[0] = amounts[0].sub(feeAmountTarget);
        }
    }

    function _swapEthFeeWork(uint[] memory amounts) internal virtual returns (uint[] memory amountberk) {
        uint[] memory amountberk= amounts;
        if(swapFee > 0 && address(feeAddress) != address(0)){
            uint feeAmountTarget = amounts[0];
            feeAmountTarget = feeAmountTarget.mul(swapFee).div(10000).add(1);
            IWETH(WETHs).transfer(feeAddress,feeAmountTarget);
            amountberk[0] = amounts[0].sub(feeAmountTarget);
        }
    }

    function _swapAddLiquidityFee(address tokenA,uint amountA,address tokenB,uint amountB) internal virtual returns (uint _amountA,uint _amountB) {
        uint _amountA = amountA;
        uint _amountB = amountB;
        if(addLiquidityFee > 0 && address(feeAddress) != address(0)){
            uint  feeAmountTargetA = amountA.mul(addLiquidityFee).div(10000).add(1);
            uint  feeAmountTargetB = amountB.mul(addLiquidityFee).div(10000).add(1);
            TransferHelper.safeTransferFrom(
                tokenA, msg.sender,feeAddress ,feeAmountTargetA
            );
            TransferHelper.safeTransferFrom(
                tokenB, msg.sender,feeAddress ,feeAmountTargetB
            );
            _amountA = amountA.sub(feeAmountTargetA);
            _amountB = amountB.sub(feeAmountTargetB);
        }
    }

    function _swapAddEthLiquidityFee(address tokenA,uint amountA,uint amountETH) internal virtual returns (uint _amountA,uint _amountETH) {
        uint _amountA = amountA;
        uint _amountETH = amountETH;
        if(addLiquidityFee > 0 && address(feeAddress) != address(0)){
            uint  feeAmountTargetA = amountA.mul(addLiquidityFee).div(10000).add(1);
            uint  feeAmountTargetEth = amountETH.mul(addLiquidityFee).div(10000).add(1);
            TransferHelper.safeTransferFrom(
                tokenA, msg.sender,feeAddress ,feeAmountTargetA
            );
            IWETH(WETHs).transfer(feeAddress, amountETH);
            _amountA = amountA.sub(feeAmountTargetA);
            _amountETH = amountETH.sub(feeAmountTargetEth);
        }
    }

    function _swapRemoveLiquidityFee(address tokenA,uint amountA,address tokenB,uint amountB) internal virtual returns (uint _amountA,uint _amountB) {
        uint _amountA = amountA;
        uint _amountB = amountB;
        if(removeLiquidityFee > 0 && address(feeAddress) != address(0)){
            uint  feeAmountTargetA = amountA.mul(removeLiquidityFee).div(10000).add(1);
            uint  feeAmountTargetB = amountB.mul(removeLiquidityFee).div(10000).add(1);
            TransferHelper.safeTransferFrom(
                tokenA, msg.sender,feeAddress ,feeAmountTargetA
            );
            TransferHelper.safeTransferFrom(
                tokenB, msg.sender,feeAddress ,feeAmountTargetB
            );
            _amountA = amountA.sub(feeAmountTargetA);
            _amountB = amountB.sub(feeAmountTargetB);
        }
    }

    function _swapRemoveEthLiquidityFee(address tokenA,uint amountA,uint amountETH) internal virtual returns (uint _amountA,uint _amountETH) {
        uint _amountA = amountA;
        uint _amountETH = amountETH;
        if(removeLiquidityFee > 0 && address(feeAddress) != address(0)){
            uint  feeAmountTargetA = amountA.mul(removeLiquidityFee).div(10000).add(1);
            uint  feeAmountTargetEth = amountETH.mul(removeLiquidityFee).div(10000).add(1);
            TransferHelper.safeTransferFrom(
                tokenA, msg.sender,feeAddress ,feeAmountTargetA
            );
            IWETH(WETHs).transfer(feeAddress, amountETH);
            _amountA = amountA.sub(feeAmountTargetA);
            _amountETH = amountETH.sub(feeAmountTargetEth);
        }
    }
}
