# Mable Back End Code Test

## Running it

The whole toolchain is in Docker, so no Ruby install is needed.

```bash
docker compose build
docker compose run --rm app bundle install
docker compose run --rm app bin/rails db:prepare
docker compose run --rm app bin/rails "accounts:load[docs/mable_account_balances.csv]"
docker compose run --rm app bin/rails "transfers:process[docs/mable_transactions.csv]"
```

## Tests

```bash
docker compose run --rm app bundle exec rspec
```

Unit specs per class, plus one e2e spec (happy path) that runs both rake tasks over the supplied CSVs and asserts the closing balances.

## Assumptions
- Transaction amount should always be a positive, non-zero number
- The source account must have a balance greater than or equal to the transaction amount
- Source and destination account number should not be the same
- Both source and destination account must exist
- The balance importer should be idempotent. If the account number already exists, update the balance with the value from the CSV
- Transactions should be parsed and applied in the order they appear in the CSV
- Output will be in the form of a simple report outlining the applied and rejected transactions and the closing balances
