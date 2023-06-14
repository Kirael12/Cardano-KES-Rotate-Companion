# Cardano-KES-Rotate-Companion
This script helps Pool Operator with KES Rotation and Operational Certificate generation.
It is designed for Coincashew installation.

# What it does
- Check KES period and counter on chain
- Ask user if he wants to backup current KES keys and NODE cert
- Ask user if he wants to rotate KES keys
- Calculate Starting KES Period
- Provide next-steps to generate new OP cert

<img width="997" alt="Capture d’écran 2023-06-14 à 16 01 03" src="https://github.com/Kirael12/Cardano-KES-Rotate-Companion/assets/113426048/2935173b-3cca-459d-9dab-b1e56d9787c8">

<img width="846" alt="Capture d’écran 2023-06-14 à 16 01 26" src="https://github.com/Kirael12/Cardano-KES-Rotate-Companion/assets/113426048/de6f639b-427d-45de-8660-eee476e212b4">

<img width="943" alt="Capture d’écran 2023-06-14 à 16 00 30" src="https://github.com/Kirael12/Cardano-KES-Rotate-Companion/assets/113426048/2eaf74f2-6bc6-416d-a233-c9432bfdd1e3">

# Pre-requisite
Cardano Node setup with Coincashew Guide : https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node)

# How to use
simply run the script on your Block Producer Node
```shell
./rotateKES.sh
```

# Changelog
v2.0.0

- Add KES period calculation and alerts
- Add user prompts
- Improved backup process
- Next-Steps section

v1.0.0

- Initial release
