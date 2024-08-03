import add_two_numbers.{type ListNode, ListNode, add_two_numbers}
import gleam/option.{type Option, None, Some}
import gleeunit/should

fn list_to_node(ls: List(inner)) -> Option(ListNode(inner)) {
  case ls {
    [last] -> Some(ListNode(last, None))
    [first, ..rest] -> Some(ListNode(first, list_to_node(rest)))
    [] -> None
  }
}

pub fn example1_test() {
  add_two_numbers(list_to_node([2, 4, 3]), list_to_node([5, 6, 4]))
  |> should.equal(list_to_node([7, 0, 8]))
}

pub fn example2_test() {
  add_two_numbers(list_to_node([0]), list_to_node([0]))
  |> should.equal(list_to_node([0]))
}

pub fn example3_test() {
  add_two_numbers(
    list_to_node([9, 9, 9, 9, 9, 9, 9]),
    list_to_node([9, 9, 9, 9]),
  )
  |> should.equal(list_to_node([8, 9, 9, 9, 0, 0, 0, 1]))
}
