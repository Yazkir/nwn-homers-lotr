# Reboot Schedule Reference

The daily restart is a two-layer system. Both layers must be changed together whenever you move the schedule.

## How the two layers work

| Layer | What it does | Where configured |
|---|---|---|
| **Anvil plugin** (`ServerRestartManager`) | Broadcasts countdown warnings (60/30/15/10/5/1 min), exports all characters, shuts the NWN server down cleanly | `ANVIL_RESTART_DAILY=HH:MM` in `server.env` |
| **OS timer** (`nwn-reboot.timer`) | Reboots the machine a few minutes after the server shuts down; NWN auto-starts on boot | `/etc/systemd/system/nwn-reboot.timer` — `OnCalendar=` line |

Normal production schedule: **server shuts at 03:00, OS reboots at 03:03**.

---

## enable
sudo systemctl enable --now nwn-reboot.timer

## Changing the OS timer (Linux side)

1. Edit the timer unit file:
   ```bash
   sudo nano /etc/systemd/system/nwn-reboot.timer
   ```
   Change the `OnCalendar=` line, e.g. for a 14:00 test run:
   ```ini
   OnCalendar=*-*-* 14:00:00
   ```

one-line version
  sudo sed -i 's/OnCalendar=.*/OnCalendar=*-*-* 03:01:00/' /etc/systemd/system/nwn-reboot.timer

2. Reload and restart the timer:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart nwn-reboot.timer
   ```

3. Verify the next fire time:
   ```bash
   systemctl list-timers nwn-reboot.timer
   ```
   The `NEXT` column should show the new time.

### Disabling the OS reboot (turning it off)

To stop the daily OS reboot entirely:
```bash
sudo systemctl disable --now nwn-reboot.timer
```
- `disable` removes it from `timers.target`, so it won't arm on future boots.
- `--now` also stops the timer already armed this boot. Plain `disable` (without
  `--now`) leaves the current timer running until the next reboot.

Verify it's off:
```bash
systemctl is-enabled nwn-reboot.timer        # -> disabled
systemctl list-timers --all nwn-reboot.timer # nwn-reboot.timer should not show an active NEXT time
```

Re-enable it later:
```bash
sudo systemctl enable --now nwn-reboot.timer
```

> ⚠️ **This only stops the OS reboot, not the in-game shutdown.** The Anvil
> `ServerRestartManager` still saves characters and shuts the NWN server down at
> `ANVIL_RESTART_DAILY`. The server normally comes back *because the machine
> reboots and the `homers-lotr-server.service` boot service relaunches it* — and
> that service is `Restart=on-failure`, so it will **not** relaunch after a clean
> Anvil shutdown. Net effect: with the OS timer off but Anvil still scheduled,
> the server shuts down at the configured time and **stays down** until you start
> it manually (`systemctl --user start homers-lotr-server`) or reboot.
>
> To turn the daily restart **off completely**, also disable the Anvil side —
> clear `ANVIL_RESTART_DAILY` in `server.env` (see next section) and restart the
> container so no daily in-game shutdown is scheduled.

---

## Changing the NWN-side shutdown (Anvil plugin)

Edit `server.env` — keep the Anvil time **3 minutes before** the OS timer:
```
ANVIL_RESTART_DAILY=13:57   # if OS reboots at 14:00
```

Then restart the NWN container so it picks up the new env var:
```bash
bin/serve stop
bin/serve start
```
(or however you normally restart the server)

---

## Restoring 3 am production schedule

Reverse both changes:
- `server.env`: `ANVIL_RESTART_DAILY=03:00`
- `/etc/systemd/system/nwn-reboot.timer`: `OnCalendar=*-*-* 03:03:00`
- Then `sudo systemctl daemon-reload && sudo systemctl restart nwn-reboot.timer` and restart the container.

---

## Auto-login after reboot (GDM)

The June 2026 reboot failed because the machine came up at the GDM login screen instead of auto-logging in, so the NWN start-up programs never ran.

Auto-login on Fedora Silverblue/Atomic is controlled by GDM. Check and set it:

```bash
sudo cat /etc/gdm/custom.conf
```

The `[daemon]` section must contain:
```ini
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=james
```

If it is missing or `AutomaticLoginEnable=False`, edit the file:
```bash
sudo nano /etc/gdm/custom.conf
```

**Confirm this is set correctly before the daytime test.** After a successful daytime test cycle confirms auto-login and NWN auto-start are both working, restore the 3 am schedule in both places.
