import random
import string

def generate_password(length=12):
    """Generate a random password with letters, digits, and symbols"""
    chars = string.ascii_letters + string.digits + "!@#$%^&*()"
    password = ''.join(random.choice(chars) for _ in range(length))
    return password

def check_strength(password):
    """Check if a password is strong (has uppercase, lowercase, digits, symbols)"""
    has_upper = any(c.isupper() for c in password)
    has_lower = any(c.islower() for c in password)
    has_digit = any(c.isdigit() for c in password)
    has_symbol = any(c in "!@#$%^&*()" for c in password)
    
    strength = "Weak"
    if len(password) >= 12 and has_upper and has_lower and has_digit and has_symbol:
        strength = "Very Strong"
    elif len(password) >= 8 and (has_upper + has_lower + has_digit + has_symbol) >= 3:
        strength = "Strong"
    elif len(password) >= 6:
        strength = "Medium"
    
    return strength

def save_passwords(passwords, filename="passwords.txt"):
    """Save passwords to a file"""
    with open(filename, "w") as f:
        for pwd in passwords:
            f.write(f"{pwd}\n")
    print(f"Saved {len(passwords)} passwords to {filename}")

def main():
    print("=== Random Password Generator ===")
    num_passwords = int(input("How many passwords to generate? "))
    length = int(input("Password length? "))
    
    passwords = []
    for _ in range(num_passwords):
        pwd = generate_password(length)
        strength = check_strength(pwd)
        passwords.append(f"{pwd} ({strength})")
        print(f"Generated: {pwd} | Strength: {strength}")
    
    save_passwords(passwords)

if __name__ == "__main__":
    main()
