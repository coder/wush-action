import os
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path


@dataclass
class Case:
    os: str
    arch: str


os_variants = ["Windows", "macOS", "Linux"]
arch_variants = ["X64", "ARM64"]

cases: list[Case] = []

for os_variant in os_variants:
    for arch_variant in arch_variants:
        cases.append(Case(os=os_variant, arch=arch_variant))

# Create temporary directory
tmp_dir = tempfile.mkdtemp()
print(f"Temporary directory: {tmp_dir}")

for case in cases:
    print(f"🔄 Testing {case.os}-{case.arch}")

    # Create variant directory
    variant_dir = Path(tmp_dir) / f"download-wush-{case.os}-{case.arch}"
    variant_dir.mkdir(exist_ok=True)

    # Change to variant directory
    os.chdir(variant_dir)

    # Run download script with environment variables
    env = os.environ.copy()
    env["ARG_OS"] = case.os
    env["ARG_ARCH"] = case.arch

    # Get path to download script relative to test.py
    script_path = Path(__file__).parent / "download-wush.sh"

    try:
        result = subprocess.run(
            ["bash", str(script_path)],
            env=env,
            capture_output=True,
            text=True,
            check=True,
        )
        print(f"Script output: {result.stdout}")

        # Assert wush executable exists
        wush_path = variant_dir / "wush"
        assert wush_path.exists(), f"wush executable not found in {variant_dir}"
        assert wush_path.is_file(), f"wush is not a file in {variant_dir}"

        # Check if it's executable
        assert os.access(wush_path, os.X_OK), f"wush is not executable in {variant_dir}"

        print(f"✅ Successfully downloaded and verified wush for {case.os}-{case.arch}")

    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to download wush for {case.os}-{case.arch}")
        print(f"Error: {e.stderr}")
        raise
    except AssertionError as e:
        print(f"❌ Assertion failed for {case.os}-{case.arch}: {e}")
        raise

print(f"\nAll tests passed! Temporary directory: {tmp_dir}")
