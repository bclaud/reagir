import { watch } from "fs/promises";

/**
 * Watches a directory and handles file events.
 * @param {string} dir - Directory to watch.
 * @param {function} [onEvent] - Callback for each event.
 */
export async function watchDirectory(dir, onEvent) {
  const watcher = watch(dir, { recursive: true });
  for await (const event of watcher) {
    onEvent(event.filename, event.eventType);
  }
}

