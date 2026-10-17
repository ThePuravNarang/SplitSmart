# SplitSmart

SplitSmart is a beginner-level Dart program for splitting group expenses.

## Features

- Add group members with unique names.
- Record expenses with a title, amount, payer, category, and participants.
- Split each expense equally between the selected participants.
- List all expenses.
- Filter expenses by member or category.
- Show how much each member paid, their share, and their net balance.
- Show clear errors for duplicate members, unknown members, invalid amounts, and empty participant lists.

## How to run

1. Install the Dart SDK from https://dart.dev/get-dart if you want to run it on your computer.
2. Save the program as `main.dart`.
3. Open a terminal in the folder containing the file.
4. Run:

```bash
dart run main.dart
```

You can also paste the code into https://dartpad.dev/ and press Run. The program uses example data in `main()` so no typing is required.

## Example

Three members — Asha, Ravi, and Neha — share a dinner costing INR 900. Asha pays the full amount, so each person's share is INR 300. Asha's net balance for that expense is +INR 600, while Ravi and Neha each have a net balance of -INR 300.

The sample program also includes a second expense with Ravi as the payer to demonstrate multiple payers.
