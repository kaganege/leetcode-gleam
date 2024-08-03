import gleam/list.{Continue, Stop}

fn enumerate(list: List(value)) -> List(#(Int, value)) {
  list
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

pub fn two_sum(nums: List(Int), target: Int) -> List(Int) {
  nums
  |> enumerate
  |> list.fold_until([], fn(l, a) {
    let #(i, a) = a
    let r =
      nums
      |> enumerate
      |> list.fold_until([], fn(_, b) {
        let #(j, b) = b

        case i == j {
          True -> Continue([])
          False ->
            case a + b == target {
              True -> Stop([i, j])
              False -> Continue([])
            }
        }
      })

    case r {
      [] -> Continue(l)
      _ -> Stop(r)
    }
  })
}
