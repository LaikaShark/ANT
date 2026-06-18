# ~ANT

```
 __     ,
(__).o.@c
 /  |  \ 

```

distributed version control written in ~ATH. tracks files as snapshots in chambers (commits), organized by tunnels (branches). push/pull to a ~colony server for remote storage.

requires `athc` compiler. compile and run:

    cd ant && athc ant.ath -o ant && ./ant <command> [args...]

install for user:

    cp ant ~/.local/bin/

install globally:

    cp ant /usr/local/bin/

## storage

all state lives in `.ant/` at the working directory root:

    .ant/
      HEAD          current tunnel name
      next_id       monotonic chamber counter
      forage        staged filenames, newline-separated
      refs/<name>   tunnel → chamber id mapping
      chambers/<id>/
        parent      parent chamber id (0 = root)
        message     commit message
        name        optional chamber name (set by dig)
        files       manifest of tracked filenames
        0, 1, ...   file blobs, indexed to match manifest order

chamber id `0` means no parent. ids increment from 1.

## commands

    ant hatch                   initialize colony (.ant/ structure)
    ant collect <file>          stage file to forage pile
    ant dig <message> [<name>]  commit foraged files into new chamber, optionally name it
    ant log                     walk chamber history backwards from HEAD
    ant status                  show tunnel, forage pile, modified files
    ant diff                    line-by-line diff of working tree vs HEAD chamber
    ant fission                 list tunnels
    ant fission <name>          create tunnel at current HEAD
    ant fission <name> <ref>    create tunnel at chamber <ref>, switch to it, restore working tree
                                <ref> is a numeric chamber id or a chamber name set by dig
    ant tunnel <name>           switch to tunnel, restore working tree
    ant splice <branch>         three-way merge of branch into current tunnel
    ant transplant <src> [dst]  copy colony to new location (defaults to <src>-colony)

## networking

push and pull require a running ~colony server.

    ant deliver <host> <port> <colony-id> <password>
    ant gather <host> <port> <colony-id> <password>

`deliver` pushes all local state (HEAD, refs, chambers) to server. `gather` pulls remote state and restores working tree. first connection with an unknown colony-id registers it; subsequent connections must match the password.

## splice (merge)

walks both tunnel histories to find common ancestor. per-file three-way merge:

- only ours changed → keep ours
- only theirs changed → take theirs
- both changed → conflict markers (`<<<<<<<` / `=======` / `>>>>>>>`)
- file only in theirs → added

conflicts written to working tree. resolve manually, then `collect` and `dig`.

## reverting

no destructive reset. use `fission` to branch from any historical chamber:

    ant log                        # find target chamber id
    ant fission rollback 3         # branch at chamber 3 by id
    ant fission rollback v1.0      # branch at chamber named "v1.0"

previous work preserved — old branch still at its tip, reachable via `ant tunnel`.
