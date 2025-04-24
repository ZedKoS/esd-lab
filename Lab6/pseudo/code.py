import random

# Constants
WORD_SIZE = 8
ADDRESS_SIZE = 4

# Make two memory arrays MEM_A and MEM_B of size 2^ADDRESS_SIZE
# Fill MEM_A with random integer values with bit size WORD_SIZE
MEM_A = [random.randint(-2**(WORD_SIZE-1), 2**(WORD_SIZE-1)-1) for _ in range(2**ADDRESS_SIZE)]
MEM_B = [0 for _ in range(2**ADDRESS_SIZE)]
power_alarms = [0 for _ in range(2**ADDRESS_SIZE)]
    
error_prev = 0

for i in range(len(MEM_A)):
    # turn MEM_A[i] into two values: signed error (most significant 7 bits) and turn (least significant 1 bit)
    error = (MEM_A[i] >> 1) & 0x7F  # Get the most significant 7 bits
    turn = MEM_A[i] & 0x01

    # Make error a signed integer
    if error > 63:
        error = error - 128

    # Calculate power_raw based on the turn value
    if turn == 0:
        power_raw = 2.25*error + 1.75*error_prev
    else:
        power_raw = 1.25*error + 0.875*error_prev

    error_prev = error
    
    # Check if power_raw is representable in WORD_SIZE bits.
    # If so save it to power and set power_alarm to 0,
    # else make power saturate and set power_alarm to 1
    if power_raw > 2**(WORD_SIZE-1)-1:
        power = 2**(WORD_SIZE-1)-1
        power_alarm = 1
    elif power_raw < -2**(WORD_SIZE-1):
        power = -2**(WORD_SIZE-1)
        power_alarm = 1
    else:
        power = int(floor(power_raw))
        power_alarm = 0
    
    # Save to MEM_B[i] and power_alarms[i]
    MEM_B[i] = power
    power_alarms[i] = power_alarm

# Save MEM_A, MEM_B and power_alarms to separate files,
# separating each value by newline
def save_to_file(filename, data):
    with open(filename, 'w') as f:
        for item in data:
            f.write(f"{item}\n")

save_to_file('MEM_A.txt', MEM_A)
save_to_file('MEM_B.txt', MEM_B)
save_to_file('power_alarms.txt', power_alarms)
