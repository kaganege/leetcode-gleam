import gleam/list
import gleeunit/should
import median_of_two_sorted_arrays.{binary_search, native, two_pointer}

const methods = [native, two_pointer, binary_search]

pub fn example1_test() {
  methods
  |> list.each(fn(m) { m([1, 3], [2]) |> should.equal(2.0) })
}

pub fn example2_test() {
  methods
  |> list.each(fn(m) { m([1, 2], [3, 4]) |> should.equal(2.5) })
}
