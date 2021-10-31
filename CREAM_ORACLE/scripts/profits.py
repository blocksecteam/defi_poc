from brownie import interface

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
            '0x4112a717edD051F77d834A6703a1eF5e3d73387F']

def main():
    for ctoken in ctokens:
        t = interface.ICrErc20(ctoken)
        underlying_token = interface.ERC20(t.underlying())
        # print(f'underlying token address: {underlying_token.address}')
        print(f'{underlying_token.symbol()}, ')
        