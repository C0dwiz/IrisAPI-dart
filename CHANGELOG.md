## 5.0.0

- Updated library to match Iris API v0.5.
- Fixed endpoint paths and response parsing for `updates/getUpdates`, `trade/orderbook`, and `/iris_agents`.
- Updated pockобнови примерыet transfer parameters to use `amount` for sweets and gold transfers.
- Added Telegram Stars support: `giveTgStars`, `getTgStarsHistory`, `buyTgStars`, `getTgStarsPrice`.
- Added NFT support: `nft/give`, `nft/info`, `nft/list`, `nft/history` with new models and methods.
- Extended models: `Balance` now includes `tgstars`, and `UserPocketResult` now uses typed fields.
- Marked `trade/my_orders`-based flow as deprecated for API v0.5 compatibility.
- Updated README to reflect new methods and deprecations.

## 2.0.0

- Fixed analyzer issues.
- Refactored the code to use super parameters.
- Updated the example.

## 1.0.0

- Initial version.