#!/bin/bash

# Function to generate a random password
generate_password() {
    local password=""
    local lowercase="abcdefghijklmnopqrstuvwxyz"
    local uppercase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local digits="0123456789"
    local special_chars="!@#$%^&*()_-+=<>?/,.|"

    # Generate a random hexadecimal number greater than 1
    hex_number=$(printf '%x\n' $(( RANDOM % 4095 + 2 )))

    # Generate a random octal number greater than 1
    oct_number=$(printf '%o\n' $(( RANDOM % 4095 + 2 )))

    # Add hexadecimal and octal numbers to the password
    password+="0x$hex_number"
    password+="0o$oct_number"

    # Generate random lowercase letters
    for ((i=0; i<3; i++)); do
        password+=${lowercase:$((RANDOM % ${#lowercase})):1}
    done

    # Generate random uppercase letters
    for ((i=0; i<5; i++)); do
        password+=${uppercase:$((RANDOM % ${#uppercase})):1}
    done

    # Generate random digits
    for ((i=0; i<13; i++)); do
        password+=${digits:$((RANDOM % ${#digits})):1}
    done

    # Generate random special characters
    for ((i=0; i<64-${#password}; i++)); do
        password+=${special_chars:$((RANDOM % ${#special_chars})):1}
    done

    # Shuffle the password
    password=$(echo "$password" | fold -w1 | shuf | tr -d '\n')

    echo "$password"
}

# Main script
password=""
while true; do
    password=$(generate_password)
    if [[ ${#password} -gt 8 && ${#password} -le 64 ]]; then
        if [[ "$password" =~ [[:lower:]] && "$password" =~ [[:upper:]] && "$password" =~ [0-9] ]]; then
            if ! grep -qFx "$password" /usr/share/dict/words; then
                sum=0
                for ((i=0; i<${#password}; i++)); do
                    if [[ "${password:$i:1}" =~ [0-9] ]]; then
                        sum=$((sum + ${password:$i:1}))
                    fi
                done
                if [[ $sum -eq 160 ]]; then
                    break
                fi
            fi
        fi
    fi
done

echo "Generated Password: $password"

