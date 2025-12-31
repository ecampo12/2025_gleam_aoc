import day01.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const input = "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

pub fn part1_test() {
  part1(input) |> should.equal(3)
}

pub fn part2_test() {
  part2(input) |> should.equal(6)
}
