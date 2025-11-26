import re
import sys
from pathlib import Path

log = Path('run.log')
if not log.exists():
    print('run.log not found. Please run the simulation and redirect output to run.log:')
    print("  .\\gradlew.bat run > run.log 2>&1")
    sys.exit(2)

pattern = re.compile(r"\[House\]\s+(\w+)\s+(START|DONE)\s+@\s+(\d+)")

events = {}
for line in log.read_text(encoding='utf-8', errors='ignore').splitlines():
    m = pattern.search(line)
    if m:
        op, phase, ts = m.group(1), m.group(2), int(m.group(3))
        events.setdefault(op, []).append((phase, ts))

required_ops = ['installPlumbing', 'installElectricalSystem', 'paintExterior', 'paintInterior']
for op in required_ops:
    if op not in events:
        print(f'Missing events for {op} — verifier cannot assert ordering')
        # continue but will likely fail below

# helper to get start and done timestamps

def get_start_done(op):
    lst = events.get(op, [])
    start = min((ts for phase, ts in lst if phase=='START'), default=None)
    done = max((ts for phase, ts in lst if phase=='DONE'), default=None)
    return start, done

p_start, p_done = get_start_done('installPlumbing')
e_start, e_done = get_start_done('installElectricalSystem')
pe_start, pe_done = get_start_done('paintExterior')
pi_start, pi_done = get_start_done('paintInterior')

print('Timestamps (ms since epoch):')
print(f'  plumbing   start={p_start} done={p_done}')
print(f'  electrical start={e_start} done={e_done}')
print(f'  paintExt   start={pe_start} done={pe_done}')
print(f'  paintInt   start={pi_start} done={pi_done}')

ok = True
# Check plumbing and electrical overlap: startA <= doneB and startB <= doneA
if None in (p_start, p_done, e_start, e_done):
    print('Insufficient plumbing/electrical timestamps to determine overlap.')
    ok = False
else:
    overlap = (p_start <= e_done) and (e_start <= p_done)
    print('Plumbing and electrical overlap:', overlap)
    if not overlap:
        ok = False

# Check paintings start after both done
if None in (pe_start, pi_start, p_done, e_done):
    print('Insufficient painting timestamps to determine ordering.')
    ok = False
else:
    painting_after = (pe_start >= p_done) and (pe_start >= e_done) and (pi_start >= p_done) and (pi_start >= e_done)
    print('Painting (both) start after both plumbing and electrical done:', painting_after)
    if not painting_after:
        ok = False

if ok:
    print('\nVERIFICATION: OK — organisation modification satisfied')
    sys.exit(0)
else:
    print('\nVERIFICATION: FAILED — organisation modification not satisfied')
    sys.exit(1)
