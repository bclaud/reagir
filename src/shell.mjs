import { $ } from "bun";

export async function shell(cmd) {
  try {
    const result = await $`${({ raw: cmd })}`;

    if (result.exitCode > 0) return result.stderr.toString()
    return result.text();
  } catch (e) {
    return e.toString()
  }
}

