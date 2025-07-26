# Wush Action

Wush Action lets you SSH into GitHub Actions using [wush](https://github.com/coder/wush).

![wush-action](https://github.com/user-attachments/assets/b375e30b-bc7e-479e-b55a-69ee16abc8fd)

## Usage

1. Add `coder/wush-action` to a GitHub Actions workflow:

```yaml
jobs:
  wush:
    timeout-minutes: 20
    steps:
      ...
      
      - uses: coder/wush-action@1.0.0
        timeout-minutes: 20

      ...
```

2. Copy the authentication key from GitHub Actions logs:

<img width="798" height="184" alt="Screenshot 2025-07-26 at 21 00 22" src="https://github.com/user-attachments/assets/f541c9f7-f778-4d6c-a9f0-d19c8154fc61" />

3. Install [wush](https://github.com/coder/wush) on your local machine, run `wush ssh`, and paste the key.

<img width="1047" height="284" alt="Screenshot 2025-07-26 at 21 02 39 1" src="https://github.com/user-attachments/assets/0e9a008d-10a2-4ad9-9220-37975021c2e6" />

4. You're in!

<img width="1046" height="271" alt="Screenshot 2025-07-26 at 21 04 11" src="https://github.com/user-attachments/assets/554eb0d9-4caa-4a3b-80c0-193bc202f2bc" />

## Security

[Wush](https://github.com/coder/wush) establishes a Wireguard tunnel between your local machine and a GitHub Actions runner - traffic is E2E-encrypted.
It doesn't require you to trust any 3rd party authentication or relay servers, instead using x25519 keys to authenticate connections.
