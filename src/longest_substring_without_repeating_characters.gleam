import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn length_of_longest_substring(s: String) -> Int {
  let #(max_len, _, _) =
    s
    |> string.split("")
    |> list.index_fold(#(0, 0, dict.new()), fn(acc, ch, i) {
      let #(max_len, start, char_map) = acc

      let start = int.max(start, char_map |> dict.get(ch) |> result.unwrap(0))
      let max_len = int.max(max_len, i - start + 1)

      #(max_len, start, char_map |> dict.insert(ch, i + 1))
    })

  max_len
}
