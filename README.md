# Character Count

Although Elixir is not an ideal choice for a CLI app, I chose it because I thought utilizing pattern matching along with the nice streaming API would lead to a clean solution without the need for a lot of control flow.

## Usage

```
Usage: mix run counter.exs <options> <infile>

Options:
--line - Get line count
--word - Get word count
--character - Get character count
--all - Get all of the above counts
--report <outfile> - Write report of counts to a file
```

## Tests

This program was tested for consistency with `wc`.
