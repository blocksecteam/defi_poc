from brownie import accounts, interface, web3, chain, Luck

uniswap_factory = interface.UniswapV2Factory(
    '0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f')
uniswap_router = interface.UniswapV2Router(
    '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D')
wise_weth_pair = interface.UniswapV2Pair(
    '0x21b8065d10f73EE2e260e5B47D3344d3Ced7596E')

amp = interface.AMP('0xfF20817765cB7f73d4bde2e66e067E58D11095C2')
weth = interface.WETH('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2')

cramp = interface.crAMP('0x2Db6c82CE72C8d7D770ba1b5F5Ed0b6E075066d6')
ceth = interface.cEther('0xD06527D5e56A3495252A528C4987003b712860eE')
comptroller = interface.Comptroller(
    '0x02E795EEc131246128346D17d2f564D7bF7C705b')
unitroller = interface.Unitroller('0x3d5BC3c8d13dcB8bF317092d84783c2697AE9258')
cramp_delegate = interface.CCollateralCapErc20Delegate(
    '0x3C710B981F5Ef28DA1807ce7ED3F2a28580E0754')
oracle = interface.PriceOracleProxy(
    '0x338EEE1F7B89CE6272f302bDC4b952C13b221f1d')


def main():
    playground()


def playground():
    user0 = accounts[0]
    user1 = accounts[1]
    ceth.mint({'from': user0, 'value': web3.toWei(500, 'ether')})
    ret = ceth.balanceOfUnderlying(user0, {'from': user0}).return_value
    print(f'mint cether: {ceth.balanceOf(user0)}, balanceOfUnderlying: {ret}')

    # Note: Send Raw Tx
    # data = web3.keccak(text='enterMarkets(address[])').hex()[
    #     :10] + web3.codec.encode_abi(["address[]"], [[cramp.address]]).hex()
    # web3.eth.send_transaction(
    #     {'from': user0.address, 'to': unitroller.address, 'data': data})
    # tx = chain.get_transaction(
    #     '0xf04df11086268db7be01d7352305529517076341ca228ac4090520ce201f0834')
    # print('tx info:', tx.info())

    print('------------------- Before -----------------')
    # (isListed, collateralFactorMantissa, accountMembership, isComped)
    # collateralFactorMantissa抵押率（450000000000000000 = 0.45e18）
    print(f'cramp market status: {unitroller.markets(cramp)}')
    print(f'ceth market status: {unitroller.markets(ceth)}')
    print(f'user asset: {unitroller.getAssetsIn(user0)}')
    print(f'user liquidity: {unitroller.getAccountLiquidity(user0)}')

    # 将用500ETH抵押来的cEther进入市场
    unitroller.enterMarkets([ceth], {'from': user0})
    # Equal to unitroller.accountAssets(user0, 0)
    print(f'> user asset: {unitroller.getAssetsIn(user0)}')
    account_liquidity = unitroller.getAccountLiquidity(user0)
    print(f'> user liquidity: {account_liquidity}')
    underlying_price = oracle.getUnderlyingPrice(cramp)
    print(f'> underlying token price: {underlying_price/1e18}')
    borrow_amount = int(account_liquidity[1] / underlying_price * 1e18)
    print(
        f'> underlying token can be borrowed: {int(account_liquidity[1] / underlying_price * 1e18)}')
    reserve = amp.balanceOf(cramp)
    cramp.borrow(borrow_amount if reserve > borrow_amount else reserve, {
        'from': user0
    })

    print('------------------- After -----------------')
    print(f'user asset: {unitroller.getAssetsIn(user0)}')
    account_liquidity = unitroller.getAccountLiquidity(user0)
    print(f'user liquidity: {account_liquidity}')


def liquidition():
    borrower = accounts[1]
    luck = Luck.deploy({
        'from': borrower
    })
    luck.good_luck({
        'from': borrower
    })
    print('Now borrower(contract luck) can be Liquidation')
    liquidator = accounts[3]
    uniswap_router.swapETHForExactTokens(1e27, [weth, amp], liquidator, chain.time(
    ) + 120, {'from': liquidator, 'value': web3.toWei(100, 'ether')})
    print(f'[before] amp balance of liquidator is {amp.balanceOf(liquidator)}')
    print(
        f'[before] ceth balance of liquidator is {ceth.balanceOf(liquidator)}')
    liquidator_assets = unitroller.getAccountLiquidity(liquidator)
    print(
        f'[before] liquidator liquidity is {liquidator_assets}')
    shortfall = liquidator_assets[2]
    amp_price = oracle.getUnderlyingPrice(cramp)
    amp_amount_can_be_liquidate = shortfall / amp_price
    print(
        f'[before] borrower liquidity is {unitroller.getAccountLiquidity(luck)}')
    print(f'[before] price of amp is {amp_price}')
    print(
        f'[before] amount of amp can be liquidate is {amp_amount_can_be_liquidate}')

    print('do liquidition...')
    amp.approve(cramp, (1 << 256)-1, {
        'from': liquidator
    })
    cramp.liquidateBorrow(luck, 1e24, ceth, {'from': liquidator})
    print(f'[after] amp balance of liquidator is {amp.balanceOf(liquidator)}')
    print(
        f'[before] ceth balance of liquidator is {ceth.balanceOf(liquidator)}')
    print(
        f'[after] liquidator liquidity is {unitroller.getAccountLiquidity(liquidator)}')
    print(
        f'[after] borrower liquidity is {unitroller.getAccountLiquidity(luck)}')
    print(f'[after] price of amp is {oracle.getUnderlyingPrice(cramp)}')

    print('liquidator redeem eth...')
    print(
        f'> [before] ceth balance of liquidator is {ceth.balanceOf(liquidator)}')
    print(
        f'> [before] liquidator liquidity is {unitroller.getAccountLiquidity(liquidator)}')
    ceth.redeem(ceth.balanceOf(liquidator), {
        'from': liquidator
    })
    print(
        f'> [after] ceth balance of liquidator is {ceth.balanceOf(liquidator)}')
    print(
        f'> [after] liquidator liquidity is {unitroller.getAccountLiquidity(liquidator)}')
