# Reboot Schedule Reference

The daily restart is a two-layer system. Both layers must be changed together whenever you move the schedule.

## How the two layers work

| Layer | What it does | Where configured |
|---|---|---|
| **Anvil plugin** (`ServerRestartManager`) | Broadcasts countdown warnings (60/30/15/10/5/1 min), exports all characters, shuts the NWN server down cleanly | `ANVIL_RESTART_DAILY=HH:MM` in `server.env` |
| **OS timer** (`nwn-reboot.timer`) | Reboots the machine a few minutes after the server shuts down; NWN auto-starts on boot | `/etc/systemd/system/nwn-reboot.timer` — `OnCalendar=` line |

Normal production schedule: **server shuts at 03:00, OS reboots at 03:03**.

---

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
  sudo sed -i 's/OnCalendar=.*/OnCalendar=*-*-* 11:33:00/' /etc/systemd/system/nwn-reboot.timer

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
