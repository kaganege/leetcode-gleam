import gleeunit/should
import longest_substring_without_repeating_characters.{
  length_of_longest_substring,
}

pub fn example1_test() {
  length_of_longest_substring("abcabcbb")
  |> should.equal(3)
}

pub fn example2_test() {
  length_of_longest_substring("bbbbb")
  |> should.equal(1)
}

pub fn example3_test() {
  length_of_longest_substring("pwwkew")
  |> should.equal(3)
}
