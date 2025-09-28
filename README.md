![Banner](https://github.com/ignfer/rollback/blob/main/banner.png)

# Rollback

- `transactions you actually control`  
- `like nvim for personal budgeting`

The idea behind rollback is to create a fun way, keyboard-first, cli-like way to handle personal budgeting and keep track of your personal expenses and transactions. At least funnier than a `month-spents-september.xlsx`.

This is a personal project to get real hands-on experience with the Ruby on Rails stack and it's community.

---

# TODO v0:

## Wallets ##

- CRUD
- Wallets representing a credit card should be distinguished by some property or attribute.
- Every wallet must have only one currency defined.
- Wallets should also support transfers between them, related by `transferId`.

## Transactions ##

- CRUD

- The direction of the transaction must also be stored for simplicity ie: `PAYABLE`|`RECEIVABLE`

- Every transaction goes against a wallet.

- Transactions are composed of one or more lines.

- Even when using multiple lines, all lines must go against only one wallet and therefore only one currency.

  

## Settlements ##

- CRUD
- Match a PAYABLE transaction against a RECEIVABLE transaction or vice versa.
- The settlement could go `1 -> N` or `N -> 1`. Settlements should have a status, `PARTIAL` | `MATCHED` depending on remaining amounts.
- Total and remaining amounts must be displayed in the UI.

## Credit Cards ##

- General support
- The transactions attached to a credit card wallet should also be assigned to a period.
- Settlements between card-related transactions should be locked to the current period, i.e. add a full payment of the previous credit card period and settle all the transactions related to that period.

## Templates and shortcuts

- Support for templates when creating stuff, ie: a quick transaction like: "I bought X premium subscription" -p -w CC_USD 5 , to indicate a new payable transaction, with the description "I bought X premium subscription", go against wallet CC_USD with an amount of 5.
- Support for shortcuts to trigger actions or move across the UI.

## Advanced filtering and monthly stats

- Always visible a list of the recent spents created

- Stats and charts by wallet

- Advanced filtering of transactions

  ## Themes ##

- Support for themes

- Support for zen-like mode, to create transactions in a bulk/streamlined way.

---

## v0 — credit handling (operational definition)

- **Wallet “Card X”** (fixed currency).  
- Each **purchase** = expense in “Card X”.  
- The **statement payment** = transfer **from** “Bank Y” **to** “Card X”.  
- **Reconciliation**:  
  - **Bulk** (full month): select charges (filtered by `statementPeriod`) → `m` → pick the **payment** → becomes **matched** if amounts align; if not, **partial** with **remaining**.  
  - **1-to-1**: select charge + payment → `m`.  
- **Reconciliation rules**:  
  - Never allow a charge/payment to go beyond **matched** (prevents over-reconciliation).  
  - Allow **N payments** to the same charge (installments/partial payments) with **remaining** calculated.  
  - Viewer for **remaining to reconcile** by `statementPeriod`.

---

## Relevant rules and restrictions

- A transaction **always** belongs to **one** wallet and its **currency = wallet currency**.  
- Transfer = **two** movements linked (`transferId`), one negative (origin) and one positive (destination).  
- Reconciliation **does not change** amounts or dates; it only **relates** transactions and calculates **remaining**.  
- Reconciliation states per transaction: `unmatched | partial | matched`.  
- The balance of each wallet = sum of its transactions (with denormalization + periodic reconciliation).

---

## Critical flows

- **Full statement payment (bulk)**  
  1. Filter `wallet:Card X AND period:2025-09 AND status:unmatched`.  
  2. `Shift+↓` to select all → `m` (reconcile).  
  3. Select the **payment** from Bank Y (same period).  
  4. If amounts align → all **matched**. If not → **partial** with **remaining**.

- **Partial payment / 1-to-1**  
  1. Select 1 charge + 1 payment → `m`.  
  2. If payment < charge → charge **partial** (remaining pending).  
  3. If payment = charge → charge **matched**.  
  4. If payment > charge → suggest reconciling against more charges or mark as surplus.
