import gleam/option.{type Option, None, Some}

pub type ListNode(inner) {
  ListNode(val: inner, next: Option(ListNode(inner)))
}

fn do_add_two_number(
  n1: Option(ListNode(Int)),
  n2: Option(ListNode(Int)),
  leading: Int,
) -> Option(ListNode(Int)) {
  case n1, n2 {
    None, None ->
      case leading {
        0 -> None
        _ -> Some(ListNode(leading, None))
      }
    _, _ -> {
      let n1 = option.unwrap(n1, ListNode(0, None))
      let n2 = option.unwrap(n2, ListNode(0, None))

      let sum = n1.val + n2.val + leading
      let node =
        ListNode(sum % 10, do_add_two_number(n1.next, n2.next, sum / 10))

      Some(node)
    }
  }
}

pub fn add_two_numbers(
  l1: Option(ListNode(Int)),
  l2: Option(ListNode(Int)),
) -> Option(ListNode(Int)) {
  do_add_two_number(l1, l2, 0)
}
