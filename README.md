# Wush Action

SSH into GitHub Actions using [wush](https://github.com/coder/wush). Debug workflows as if they were running on your machine.

![wush-action](https://github.com/user-attachments/assets/b375e30b-bc7e-479e-b55a-69ee16abc8fd)

## Usage

1. Add `coder/wush-action` to a GitHub Actions workflow:

```yaml
jobs:
  wush:
    steps:
      ...

      - uses: coder/wush-action@v1.0.0
        timeout-minutes: 30

      ...
```

2. Copy the authentication key from GitHub Actions logs:

<img width="798" height="184" alt="Screenshot 2025-07-26 at 21 00 22" src="https://github.com/user-attachments/assets/f541c9f7-f778-4d6c-a9f0-d19c8154fc61" />

3. Install [wush](https://github.com/coder/wush?tab=readme-ov-file#install) on your local machine:

```bash
curl -fsSL https://github.com/coder/wush/raw/refs/heads/main/install.sh | sh
```

4. Run `wush ssh`, and paste the key.

<img width="1047" height="284" alt="Screenshot 2025-07-26 at 21 02 39 1" src="https://github.com/user-attachments/assets/0e9a008d-10a2-4ad9-9220-37975021c2e6" />

5. You're in!

<img width="1046" height="271" alt="Screenshot 2025-07-26 at 21 04 11" src="https://github.com/user-attachments/assets/554eb0d9-4caa-4a3b-80c0-193bc202f2bc" />

## Supported platforms

- Linux (`x86_64` and `arm64`)
- Windows (`x86_64` and `arm64`)
- macOS (`x86_64` and `arm64`)

## How it works

[Wush](https://github.com/coder/wush) establishes a WireGuard tunnel between your local machine and a GitHub Actions runner - traffic is E2E-encrypted.
It doesn't require you to trust any 3rd party authentication or relay servers, instead using x25519 keys to authenticate connections.

For more information, see [wush's README](https://github.com/coder/wush?tab=readme-ov-file#technical-details) and [source code](https://github.com/coder/wush).

## Usage tips

To run `coder/wush-action` regardless of whether a job succeeds or fails, consider using `${{ !cancelled() }}` instead of `${{ always() }}`:

```yaml
jobs:
  wush:
    steps:
      ...

      - name: Run wush
        if: ${{ !cancelled() }}
        uses: coder/wush-action@v1.0.0
```

`always()` is immune to cancellation, so you won't be able to stop `wush` by cancelling the workflow. Instead, you'll need to SSH into GitHub Actions and kill the `wush` process manually.
