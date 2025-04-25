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

export async function quiet_shell(cmd) {
  try {
    const result = await $`${({ raw: cmd })}`.quiet();

    if (result.exitCode > 0) return result.stderr.toString()
    return result.text();
  } catch (e) {
    return e.toString()
  }
}
