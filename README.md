# SpartanOS

WIP: Educational OS Project

Disclaimer: This is not going to replace Linux. This might have serious bugs. Even if this wasn't a WIP you probably won't be doing any serious work in this OS any time soon.

## Why SpartanOS

In this case "spartan" means nothing more than what you need. It is a core goal to avoid complexity by keeping the code base small, lightweight and easy to understand.

I will be using SpartanOS to teach myself, and hopefully others, a lot about Risc-V, OS Development, and other related information.

## Goals

1. Clean, easy to read code. Code will be self documenting but relevant comments will be included to aid understanding.
2. Reliability. Prefer working, well documented features, even if that comes at the expense of total feature set.
3. Performance. Ideally if final solution is fairly lightweight is should be quite performant as a natural result.

## Current Design Decisions

Some of these decisions are subject to change; they just form an initial guideline to get started.

1. Portability is not a huge concern at all. Right now only RISC-V is being targeted and its unlikely that all boards under this arch will be fully supported. Any similarity to POSIX is completely coincidental, don't expect to run Bash, but its likely to feel 'unixy'.
2. Support: The SiFive HiFive1 Rev B is the unofficial 32 bit hardware target goal, the BeagleV is the unofficial 64 bit hardware goal but these may change and others may be added. SpartanOS is a few versions away from being ready for hardware anyways. QEMU virt and sifive_e 'machine' support is under development now.
3. Security: If easy wins can be achieved, they will be implemented, but not a lot of focus will be spent here initially.
4. FPU: There is no plans currently to use the FPU in any way. In fact, it is hoped that FPU registers can be ignored completely on context switches for a small performance boost, though the hardware may force this.

## 10000 Foot View

-   ./\_debug = Helpful files generated on compile/runtime that aid with debugging SpartanOS
-   ./drivers = Mostly 3rd party device code ported to be compatible with SpartanOS, see individual files for attribution.
-   ./kernel = The core logic of SpartanOS
-   ./kernel/includes = The header files for SpartanOS
-   ./library = Reuseable assembly functions ported from various resources, see individual files for attribution.
-   ./tests = Tests to verify the correctness of SpartanOS

## Roadmap

-   [x] 'Boot' into kernel targeting 'sifive_e' machine on QEMU
-   [x] Print a message on 'sifive_e' target on QEMU
-   [ ] Timer interrupts
-   [ ] Processes
-   [ ] Simple Multi-Tasking
-   [ ] SMP?
-   [ ] Paging?
-   [ ] Usermode?
-   [ ] More?

## Contributing

If you have an idea on how to improve this project, your feedback, issue reports, or pull requests are most welcome! If you find anything unclear, chances are so does somebody else. Don't be afraid to ask.
