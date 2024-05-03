import json
import yaml
import re
import os

def is_ipv4(ip):
    """ Check if the string is a valid IPv4 address. """
    try:
        parts = ip.split('.')
        return len(parts) == 4 and all(0 <= int(part) < 256 for part in parts)
    except ValueError:
        return False

def process_servers(server_ips, server_hostnames):
    """ Match server IPs with hostnames, filtering for valid IPv4 addresses. """
    filtered_servers = []
    # Match first valid IPv4 address for each hostname.
    for hostname, ips in zip(server_hostnames, server_ips):
        valid_ips = [ip for ip in ips if is_ipv4(ip)]
        if valid_ips:
            filtered_servers.append((hostname, valid_ips[0]))
    return filtered_servers

def main():
    try:
        with open('output.json', 'r') as file:
            data = json.load(file)
    except Exception as e:
        print(f"Failed to read or parse output.json: {e}")
        return

    vm_groups = ['gar']  # Defined groups based on your output.tf

    for group in vm_groups:
        ips_key = f"{group}_server_ips"
        hostnames_key = f"{group}_server_hostnames"
        
        ips = data.get(ips_key, {}).get('value', [])
        hostnames = data.get(hostnames_key, {}).get('value', [])
        
        servers = process_servers(ips, hostnames)

        # Create directory for group if not exists
        dir_path = f"../ansible-{group}"
        if not os.path.exists(dir_path):
            os.makedirs(dir_path)

        # Generate inventory file
        inventory = {
            f'{group}_servers': {
                'hosts': {
                    hostname: {
                        'ansible_host': ip,
                        'ansible_user': 'ansible',
                        'ansible_ssh_private_key_file': '../secrets/id_ecdsa'
                    } for hostname, ip in servers
                }
            }
        }
        
        with open(os.path.join(dir_path, 'inventory.yml'), 'w') as file:
            yaml.dump(inventory, file, default_flow_style=False)
        print(f"Inventory for {group} servers generated at {os.path.join(dir_path, 'inventory.yml')}")

if __name__ == "__main__":
    main()
