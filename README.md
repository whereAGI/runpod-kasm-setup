# RunPod KASM Setup Script

This script sets up a RunPod KASM environment with VS Code and root permissions.

## Usage

1. Start your RunPod instance using the KASM template (e.g., `j12p0fqltt`)

2. Download and run the setup script:
```bash
wget https://raw.githubusercontent.com/whereAGI/runpod-kasm-setup/main/setup.sh
chmod +x setup.sh
sudo ./setup.sh
```

## What the script does

1. Installs VS Code
2. Configures root permissions for the KASM user
3. Sets up NVIDIA environment variables
4. Modifies KASM startup scripts for root access

## Troubleshooting

Check the logs for any errors. The script includes timestamps for easy debugging.

If you encounter any issues:
1. Check if you're running as root (`sudo`)
2. Ensure the base KASM template is working correctly
3. Review the logs in `/var/log/`

## Testing

After running the script:
1. Open VS Code to verify installation
2. Try running commands with sudo (should work without password)
3. Check NVIDIA GPU access with `nvidia-smi`

## Converting to Docker image

Once you've confirmed the script works, you can use it as a base for creating a custom Docker image. The script's steps can be converted directly into Dockerfile instructions.