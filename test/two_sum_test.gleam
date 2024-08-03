import gleeunit/should
import two_sum.{two_sum}

pub fn example1_test() {
  two_sum([2, 7, 11, 15], 9)
  |> should.equal([0, 1])
}

pub fn example2_test() {
  two_sum([3, 2, 4], 6)
  |> should.equal([1, 2])
}

pub fn example3_test() {
  two_sum([3, 3], 6)
  |> should.equal([0, 1])
}
