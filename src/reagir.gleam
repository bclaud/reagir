import argv
import gleam/io
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/result
import gleam/string

pub fn main() {
  case argv.load().arguments {
    [] -> log("usage: reagir <command>")

    command_list -> {
      let command = string.join(command_list, with: " ")

      use cwd <- promise.await(quiet_shell("pwd"))
      shell(command)
      use filename, event <- watch_directory(string.trim(cwd))
      case
        should_watch_changes(filename)
        && is_file_related_to_programming(filename),
        event
      {
        True, "rename" -> {
          log("[Change detected. Rerunning command]")
          shell(command)
          Nil
        }
        _, _ -> {
          Nil
        }
      }
    }
  }
}

@external(javascript, "./shell.mjs", "shell")
fn shell(cmd: String) -> Promise(String)

@external(javascript, "./shell.mjs", "quiet_shell")
fn quiet_shell(cmd: String) -> Promise(String)

@external(javascript, "./watcher.mjs", "watchDirectory")
fn watch_directory(
  dir: String,
  callback fun: fn(String, String) -> Nil,
) -> Promise(b)

fn log(log: String) -> Promise(Nil) {
  promise.resolve(io.println(log))
}

fn file_extension(filename: String) -> String {
  filename
  |> string.split(on: ".")
  |> list.last()
  |> result.unwrap("")
  |> string.trim()
}

fn is_file_related_to_programming(filename: String) -> Bool {
  // TODO probably getting .gitignore files and dirs is better than this naive solution
  [
    "dockerfile", "c", "cpp", "cc", "cxx", "h", "hpp", "cs", "java", "js", "mjs",
    "ts", "mts", "jsx", "tsx", "ex", "exs", "lua", "py", "php", "gleam", "rb",
    "kts", "json", "toml",
  ]
  |> list.contains(file_extension(filename))
}

fn should_watch_changes(filename: String) -> Bool {
  let contains = string.contains(filename, _)

  !contains("build")
  && !contains("dist")
  && !contains("target")
  && !contains("bin")
}
