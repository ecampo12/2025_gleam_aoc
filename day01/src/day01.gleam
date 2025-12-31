import gleam/format.{printf}
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile.{read}

fn parse(input: String) -> List(Int) {
  string.split(input, "\n")
  |> list.fold([], fn(acc, line) {
    let num =
      string.replace(line, "L", "-")
      |> string.replace("R", "")
      |> int.parse
      |> result.unwrap(-1)

    list.append(acc, [num])
  })
}

pub fn part1(input: String) -> Int {
  let #(_, count) =
    parse(input)
    |> list.fold(#(50, 0), fn(acc, turn) {
      let #(dial, count) = acc
      let new_dial = { dial + turn } % 100
      case new_dial == 0 {
        True -> #(new_dial, count + 1)
        False -> #(new_dial, count)
      }
    })
  count
}

// Gleam modulo does not behave like mathematical modulo for negative numbers
// I could've used int.modulo but i didn't want to unwrap the result.
fn true_mod(a: Int, b: Int) -> Int {
  { a % b + b } % b
}

fn divmod(a: Int, b: Int) -> #(Int, Int) {
  let div = a / b
  let rem = true_mod(a, b)
  #(div, rem)
}

pub fn part2(input: String) -> Int {
  let #(_, count) =
    parse(input)
    |> list.fold(#(50, 0), fn(acc, turn) {
      let #(dial, count) = acc
      let new_count = case turn < 0 {
        True -> {
          let #(div, mod) = divmod(turn, -100)
          case dial != 0 && dial + mod <= 0 {
            True -> count + div + 1
            False -> count + div
          }
        }
        False -> {
          let #(div, mod) = divmod(turn, 100)
          case dial + mod >= 100 {
            True -> count + div + 1
            False -> count + div
          }
        }
      }
      #(true_mod(dial + turn, 100), new_count)
    })
  count
}

pub fn main() {
  let assert Ok(input) = read("input.txt")
  let part1_ans = part1(input)
  printf("Part 1: ~b~n", part1_ans)
  let part2_ans = part2(input)
  printf("Part 2: ~b~n", part2_ans)
}
