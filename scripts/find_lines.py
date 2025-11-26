import sys
from pathlib import Path

xml_path = Path('src/org/house-os.xml')
if not xml_path.exists():
    print('XML file not found at', xml_path)
    sys.exit(1)

keywords = [
    'role id="electrician"',
    'role id="plumber"',
    'mission id="install_electrical_system"',
    'mission id="install_plumbing"',
    'goal id="electrical_system_installed"',
    'goal id="plumbing_installed"',
    'goal id="exterior_painted"',
    'goal id="interior_painted"',
    'goal id="painting_final"',
    '<scheme id="build_house_sch"',
]

with xml_path.open(encoding='utf-8') as f:
    lines = f.readlines()

print('Scanning', xml_path)
for k in keywords:
    found = False
    for i, line in enumerate(lines, start=1):
        if k in line:
            print(f"Found '{k}' at line {i}: {line.strip()}")
            found = True
            break
    if not found:
        print(f"Keyword not found: {k}")

# print a small context around painting_final
for i, line in enumerate(lines, start=1):
    if 'goal id="painting_final"' in line:
        start = max(1, i-3)
        end = min(len(lines), i+10)
        print('\nContext around painting_final (lines %d-%d):' % (start, end))
        for j in range(start-1, end):
            print(f"{j+1:4}: {lines[j].rstrip()}")
        break
