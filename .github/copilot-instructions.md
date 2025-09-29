# Copilot Instructions for USBTesla

## Project Overview
- **USBTesla** turns a Raspberry Pi Zero into a WiFi-enabled USB drive for Tesla vehicles, allowing users to update boombox and lockchime sounds over the network via a browser.
- The system automates USB drive setup and exposes a web interface for file management, eliminating the need to physically move the USB stick.

## Key Components
- `USBTesla_setup.sh`: Main setup script for preparing the Pi and installing all required services.
- `tesla-wave-manager.sh`, `usb_share.py`, and scripts in the root: Handle USB sharing, sound file management, and system automation.
- `tesla-wave-mgmt/app.py`: Flask web app for managing sound files via browser.
- `tesla-wave-mgmt/templates/`: Jinja2 HTML templates for the web UI.
- `LockChime.wav`: Example or required sound file for Tesla lock chime.

## Developer Workflows
- **Setup**: Run the setup script on a prepared Raspberry Pi Zero:  
  `bash -c "$(curl -fsSL https://raw.githubusercontent.com/iFredLouzada/USBTesla/main/USBTesla_setup.sh)"`
- **Web UI**: After setup, access the Pi at `http://USBTesla.local` to upload/manage sound files.
- **Testing**: No formal test suite; manual testing is done by running scripts and using the web UI on the Pi.
- **Debugging**: Check logs/output of shell scripts and Flask app (`tesla-wave-mgmt/app.py`).

## Project-Specific Patterns & Conventions
- **Shell scripts** are the primary automation mechanism; Python is used for the web interface.
- **File management** is handled via Flask and the FileBrowser project (see README credits).
- **Sound files** must be named and placed according to Tesla's requirements (e.g., `LockChime.wav` at the root).
- **No formal Python packaging**; scripts are run directly.
- **Raspberry Pi OS** and ExFAT formatting are assumed for the target hardware.

## Integration Points
- **External**: FileBrowser (external project, see README), Flask, and system-level USB sharing.
- **Cross-component**: Shell scripts invoke Python and system commands; the Flask app interacts with the file system for uploads.

## Examples
- To add a new sound, upload it via the web UI or place it in the correct directory and ensure the filename matches Tesla's requirements.
- To update the web UI, edit `tesla-wave-mgmt/app.py` and the corresponding template in `tesla-wave-mgmt/templates/`.

## References
- See `README.md` for user-facing setup and usage instructions.
- For hardware prep, see the linked wiki in the README.

---

**AI agents:**
- Prioritize automation via shell scripts and respect the file/OS conventions described above.
- When in doubt, check the setup script and Flask app for the main logic and integration points.
