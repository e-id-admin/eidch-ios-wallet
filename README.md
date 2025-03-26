![swiyu GitHub banner](https://github.com/swiyu-admin-ch/swiyu-admin-ch.github.io/blob/main/assets/images/github-banner.jpg)

# swiyu - iOS wallet

An official Swiss Government project made by the [Federal Office of Information Technology, Systems and Telecommunication FOITT](https://www.bit.admin.ch/)
as part of the electronic identity (E-ID) project.

## Table of Contents

- [Overview](#overview)
- [Installation and building](#installation-and-building)
- [Known Issues](#known-issues)
- [Contributions and feedback](#contributions-and-feedback)
- [License](#license)

## Overview

This repository is part of the ecosystem developed for the future official Swiss E-ID.
The goal of this repository is to engage with the community and collaborate on developing the Swiss ecosystem for E-ID and other credentials.
We warmly encourage you to engage with us by creating an issue in the repository.

For more information about the project please visit the [introduction into open source of the public beta](https://github.com/e-id-admin/eidch-public-beta).

## Installation and building

The app requires at least iOS 16.<br/>
The app has been build with Xcode 16.0.

In your terminal, after having cloned the current repository, run the following command:

```bash
make setup
```

The `make` command will set everything up and provide you with an up and running project.

Once in Xcode:
- Select the `swiyu Dev` scheme
- We are using some Macros part of our development process. Make sure to trust them.
- Be aware that it's more appropriate to run on real devices rather than in Simulator because of several restrictions and KeyChain usage
- Finally, just build & run in Xcode with `command + R`

## Known Issues

The swiyu Public Beta Trust Infrastructure was deliberately released at an early stage to enable future ecosystem participants. There may still be minor bugs or security vulnerabilities in the test system. We will publish them in the near future as ‘KnownIssues’ in this repository.

## Contributions and feedback

The code for this repository is developed privately and will be released after each sprint. The published code can therefore only be a snapshot of the current development and not a thoroughly tested version. However, we welcome any feedback on the code regarding both the implementation and security aspects. Please follow the guidelines for contributing found in [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for details.
