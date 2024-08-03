import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn char_indices(s: String) -> List(#(Int, String)) {
  s
  |> string.split("")
  |> list.fold([], fn(l, val) {
    list.append(l, [
      #(
        case list.last(l) {
          Ok(#(i, _)) -> i + 1
          _ -> 0
        },
        val,
      ),
    ])
  })
}

pub fn length_of_longest_substring(s: String) -> Int {
  let #(max_len, _, _) =
    s
    |> char_indices
    |> list.fold(#(0, 0, dict.new()), fn(p, c) {
      let #(max_len, start, char_map) = p
      let #(i, ch) = c

      let start = int.max(start, char_map |> dict.get(ch) |> result.unwrap(0))
      let max_len = int.max(max_len, i - start + 1)

      #(max_len, start, char_map |> dict.insert(ch, i + 1))
    })

  max_len
}
