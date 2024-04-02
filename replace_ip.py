import os
import sys


def replace_ip_to_warp(lines: [str], dir: str):
    index = 1
    for f in os.listdir(dir):
        with open(os.path.join(dir, f), 'r') as warp:
            warp_lines = warp.readlines()
            for i in range(len(warp_lines)):
                if warp_lines[i].startswith('Endpoint = '):
                    old = warp_lines[i]
                    warp_lines[i] = 'Endpoint = '+lines[index].split(",")[0]
                    index += 1
                    print(f'name = {f} old = {old} new = {warp_lines[i]}')
        with open(os.path.join(dir, f), 'w') as warp:
            warp.writelines(warp_lines)


if __name__ == '__main__':
    print('read ip list')
    with open(sys.argv[1], 'r') as file:
        lines = file.readlines()
    if os.path.isdir(sys.argv[2]):
        print('start replace new ip')
        replace_ip_to_warp(lines, sys.argv[2])
    else:
        print('please choose dir')
