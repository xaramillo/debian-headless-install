# debian-headless-install
This repository automates the process of creating a headless installation ISO for Debian 12.

## Instructions
1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. Run the script to generate the customized ISO:
   ```bash
   ./customize_iso.sh
   ```

3. Use the generated ISO (e.g., `debian-12-headless.iso`) to perform a headless installation on your server.

## Details
- The preseed file automates the installation, including setting up SSH access.
- Modify `preseed.cfg` to customize settings like root password, hostname, or mirror URLs.
- Ensure your system has the required tools: `genisoimage`, `rsync`, and `wget`.