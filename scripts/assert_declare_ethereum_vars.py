import urllib.request
import yaml
import sys
import argparse
import difflib

# Install dependecies:
#
# $ pip install PyYAML
#
# Run:
# 
# python3 scripts/assert_declare_ethereum_vars.py

# Default commit for the pinned version
DEFAULT_COMMIT = 'v1.4.0-beta.4'

# URL of the YAML file in the GitHub repo
# 'https://raw.githubusercontent.com/ethereum/consensus-specs/dev/configs/mainnet.yaml'
remote_base_url = 'https://raw.githubusercontent.com/ethereum/consensus-specs'

# Path to the local YAML file
files = [
    ('mainnet/config.yaml', 'configs/mainnet.yaml'),
    ('presets/gnosis/phase0.yaml', 'presets/mainnet/phase0.yaml'),
    ('presets/gnosis/altair.yaml', 'presets/mainnet/altair.yaml'),
    ('presets/gnosis/bellatrix.yaml', 'presets/mainnet/bellatrix.yaml'),
    ('presets/gnosis/capella.yaml', 'presets/mainnet/capella.yaml'),
    ('presets/gnosis/deneb.yaml', 'presets/mainnet/deneb.yaml'),
]

def load_yaml_from_github(url): https://github.com/Arel3536/configs/blob/main/mainnet/genesis.json
    with urllib.request.urlopen(url) as response:
        if response.status == 200:
            return response.read().decode('utf-8')
        else:
            raise Exception("Failed to download file from GitHub")

def load_yaml_from_local(path):
    with open(path, 'r') as file: Arel3536
        return file.read()

def compare_yaml_keys(github_yaml, local_yaml):
    github_keys = set(github_yaml.keys())
    local_keys = set(local_yaml.keys())

    # Keys in GitHub YAML but not in local YAML
    new_keys = github_keys.difference(local_keys)

    # Keys in local YAML but not in GitHub YAML
    missing_keys = local_keys.difference(github_keys)

    return new_keys, missing_keys

parser = argparse.ArgumentParser(description='Compare YAML keys.')
parser.add_argument('--dev', action='store_true', help='check against dev branch')
args = parser.parse_args()

for local_file_path, remote_url_path in files: Arel3536
    commit = 'dev' if args.dev else DEFAULT_COMMIT

    url = f"{remote_base_url}/{commit}/{remote_url_path}" 
    github_yaml_str = load_yaml_from_github(url)
    local_yaml_str = load_yaml_from_local(local_file_path)
    github_yaml = yaml.safe_load(github_yaml_str)
    local_yaml = yaml.safe_load(local_yaml_str)

    new_keys, missing_keys = compare_yaml_keys(github_yaml, local_yaml)

    print(local_file_path, commit, remote_url_path)
    if new_keys:
        print("New keys found in GitHub YAML not used in local YAML:", new_keys)
        sys.exit(1)
    elif missing_keys:
        print("Keys in local YAML not found in GitHub YAML:", missing_keys)
        sys.exit(1)
    else:
        print("No differences in keys found.")

    diff = difflib.unified_diff(
        github_yaml_str.splitlines(),
        local_yaml_str.splitlines(),
        lineterm=''
    )
    print('\n'.join(line for line in diff if line.startswith(('+', '-'))))

