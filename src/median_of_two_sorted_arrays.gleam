import gleam/dict
import gleam/int
import gleam/iterator
import gleam/list.{Continue, Stop}
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/pair
import gleam/result

type IndexedList(a) =
  dict.Dict(Int, a)

type ReadyOrNot(a, b) {
  Ready(a)
  Not(b)
}

pub fn native(nums1: List(Int), nums2: List(Int)) -> Float {
  let sorted_list = nums1 |> list.append(nums2) |> list.sort(by: int.compare)
  let length = sorted_list |> list.length
  let is_length_even = length |> int.is_even
  let center = length / 2

  let enumerated = sorted_list |> list.index_map(fn(x, i) { #(i, x) })
  let f =
    enumerated |> list.key_find(center) |> result.unwrap(0) |> int.to_float

  case is_length_even {
    False -> f
    True ->
      {
        f
        +. {
          enumerated
          |> list.key_find(center - 1)
          |> result.unwrap(0)
          |> int.to_float
        }
      }
      /. 2.0
  }
}

pub fn two_pointer(nums1: List(Int), nums2: List(Int)) -> Float {
  let n1 = nums1 |> list.length
  let n2 = nums2 |> list.length
  let total = n1 + n2
  let is_even = total |> int.is_even
  let center = total / 2

  let do_two_pointer = fn(
    previous: Int,
    num1: Option(Int),
    num2: Option(Int),
    p: #(Int, Int),
  ) -> ReadyOrNot(Float, #(Int, #(Int, Int))) {
    let #(p1, p2) = p
    let check_index = fn(val: Int, p1: Int, p2: Int) -> ReadyOrNot(Float, Nil) {
      case p1 + p2 == center + 1 {
        True ->
          Ready(case is_even {
            True -> { int.to_float(previous) +. int.to_float(val) } /. 2.0
            False -> int.to_float(val)
          })
        False -> Not(Nil)
      }
    }

    case num1, num2 {
      Some(val1), Some(val2) ->
        case val1 < val2 {
          True -> {
            let p1 = p1 + 1
            case check_index(val1, p1, p2) {
              Ready(f) -> Ready(f)
              Not(_) -> Not(pair.new(val1, pair.new(p1, p2)))
            }
          }

          False -> {
            let p2 = p2 + 1
            case check_index(val2, p1, p2) {
              Ready(f) -> Ready(f)
              Not(_) -> Not(pair.new(val2, pair.new(p1, p2)))
            }
          }
        }

      Some(val1), None -> {
        let p1 = p1 + 1
        case check_index(val1, p1, p2) {
          Ready(f) -> Ready(f)
          Not(_) -> Not(pair.new(val1, pair.new(p1, p2)))
        }
      }

      None, Some(val2) -> {
        let p2 = p2 + 1
        case check_index(val2, p1, p2) {
          Ready(f) -> Ready(f)
          Not(_) -> Not(pair.new(val2, pair.new(p1, p2)))
        }
      }

      None, None -> panic
    }
  }

  let nums1 =
    nums1 |> list.index_map(fn(x, i) { pair.new(i, x) }) |> dict.from_list
  let nums2 =
    nums2 |> list.index_map(fn(x, i) { pair.new(i, x) }) |> dict.from_list

  case
    iterator.range(from: 0, to: int.max(n1, n2))
    |> iterator.fold_until(Not(#(0, #(0, 0))), fn(acc, _) {
      let assert Not(#(pre, p)) = acc

      case
        do_two_pointer(
          pre,
          nums1 |> dict.get(pair.first(p)) |> option.from_result,
          nums2 |> dict.get(pair.second(p)) |> option.from_result,
          p,
        )
      {
        Ready(f) -> Stop(Ready(f))
        Not(a) -> Continue(Not(a))
      }
    })
  {
    Ready(f) -> f
    Not(_) -> panic
  }
}

fn do_binary_search(
  a: IndexedList(Int),
  b: IndexedList(Int),
  k: Int,
  a_start: Int,
  a_end: Int,
  b_start: Int,
  b_end: Int,
) -> Float {
  case a_start > a_end, b_start > b_end {
    True, _ -> b |> dict.get(k - a_start) |> result.unwrap(0) |> int.to_float
    _, True -> a |> dict.get(k - b_start) |> result.unwrap(0) |> int.to_float
    False, False -> {
      let a_index = { a_start + a_end } / 2
      let b_index = { b_start + b_end } / 2

      let a_value = a |> dict.get(a_index) |> result.unwrap(0)
      let b_value = b |> dict.get(b_index) |> result.unwrap(0)

      case a_index + b_index < k, int.compare(a_value, b_value) {
        True, order.Lt ->
          do_binary_search(a, b, k, a_index + 1, a_end, b_start, b_end)
        True, _ -> do_binary_search(a, b, k, a_index, a_end, b_start + 1, b_end)
        False, order.Gt ->
          do_binary_search(a, b, k, a_start, a_index - 1, b_start, b_end)
        False, _ ->
          do_binary_search(a, b, k, a_start, a_end, b_start, b_index - 1)
      }
    }
  }
}

pub fn binary_search(nums1: List(Int), nums2: List(Int)) -> Float {
  let n1 = nums1 |> list.length
  let n2 = nums2 |> list.length
  let total = n1 + n2

  let nums1 =
    nums1 |> list.index_map(fn(x, i) { pair.new(i, x) }) |> dict.from_list
  let nums2 =
    nums2 |> list.index_map(fn(x, i) { pair.new(i, x) }) |> dict.from_list

  let first_search =
    do_binary_search(nums1, nums2, total / 2, 0, n1 - 1, 0, n2 - 1)

  case total |> int.is_even {
    False -> first_search
    True ->
      {
        first_search
        +. do_binary_search(nums1, nums2, total / 2 - 1, 0, n1 - 1, 0, n2 - 1)
      }
      /. 2.0
  }
}

pub fn find_median_sorted_arrays(nums1: List(Int), nums2: List(Int)) -> Float {
  binary_search(nums1, nums2)
}
