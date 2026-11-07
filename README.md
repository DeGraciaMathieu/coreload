# coreload

A tiny macOS menu bar app that shows which processes are loading your CPU.

- The menu bar shows the overall CPU load of the machine.
- The panel lists the 8 heaviest processes with their PID, memory and CPU usage in **cores** (`0.69 core` = 69 % of one core), colored orange from half a core and red from one full core.
- Each process can be stopped (`SIGTERM`) after a confirmation.

Values come from `ps`, refreshed every 3 seconds.

## Requirements

macOS 13+ and Swift (the Xcode Command Line Tools are enough).

## Build and run

```bash
./build.sh
open CpuBar.app
```
