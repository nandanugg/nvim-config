#!/bin/bash

# Default base URL, can be overridden by environment variable
BASE_URL=${BASE_URL:-"https://projectsprint.dev/api"}

# Input validation functions
validate_yes_no() {
    local input=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    [ "$input" = "y" ] || [ "$input" = "n" ] && echo "valid" || echo "invalid"
}

validate_package() {
    local input=$1
    [ "$input" = "1" ] || [ "$input" = "2" ] && echo "valid" || echo "invalid"
}

validate_length() {
    local input=$1
    [ ${#input} -gt 2 ] && [ ${#input} -lt 31 ] && echo "valid" || echo "invalid"
}

# Package and repository type functions
get_package_name() {
    [ "$1" = "1" ] && echo "monolith" || echo "microservice"
}

validate_repository() {
    [ "$1" = "1" ] || [ "$1" = "2" ] && echo "valid" || echo "invalid"
}

get_repository_name() {
    [ "$1" = "1" ] && echo "gitlab" || echo "github"
}

# HTTP request function
make_post_request() {
    local url=$1
    local data=$2
    local response_file=$(mktemp)
    local http_code=$(curl -s -w "%{http_code}" -o "$response_file" -H "Content-Type: application/json" -X POST -d "$data" "$url")
    local response=$(cat "$response_file")
    rm "$response_file"
    echo "{\"status\":$http_code,\"body\":$response}"
}

# Member management functions
get_member_input() {
    local member_number=$1
    local repo_type=$2

    while true; do
        read -p "Is there a ${member_number}th member? (y/n): " has_member
        if [ "$(validate_yes_no "$has_member")" = "valid" ]; then
            break
        else
            echo "Invalid input. Please enter y or n."
        fi
    done

    has_member=$(echo "$has_member" | tr '[:upper:]' '[:lower:]')
    if [ "$has_member" = "y" ]; then
        read -p "What's the ${member_number}th team member's name? " name
        read -p "What's the ${member_number}th team member's ${repo_type} id (without '@')? " repo_id
        read -p "What's the ${member_number}th team member's email? " email
        echo "choice:y|$name|$repo_id|$email"
    else
        echo "choice:n"
    fi
}

format_member_json() {
    local input=$1
    local team_members=$2
    local comma_prefix=${3:-true}

    local comma=""
    [ "$comma_prefix" = "true" ] && comma=","

    local choice=$(echo "$input" | cut -d'|' -f1 | cut -d':' -f2)
    if [ "$choice" = "y" ]; then
        local name=$(echo "$input" | cut -d'|' -f2)
        local repo_id=$(echo "$input" | cut -d'|' -f3)
        local email=$(echo "$input" | cut -d'|' -f4)
        echo "${team_members}${comma}{\"name\":\"$name\",\"email\":\"$email\",\"repositoryId\":\"$repo_id\"}"
    else
        echo "$team_members"
    fi
}

get_member_choice() {
    echo "$1" | cut -d'|' -f1 | cut -d':' -f2
}

# Main script starts here
echo "Welcome to ProjectSprint Registration"

# Check registration status
status_response=$(make_post_request "${BASE_URL}/registration/v1/status" "{}")
is_now_open=$(echo "$status_response" | grep -o '"isNowOpen":\s*\([^,}]*\)' | cut -d':' -f2 | tr -d '[:space:]')

if [ "$is_now_open" != "true" ]; then
    echo "The registration is currently ended, please check https://projectsprint.dev for more information about the next registration"
    exit 1
fi

# Team name input
echo "What is your team name?"
echo "(do not use any political / provoking names that offend anyone)"
while true; do
    read -p "3-31 character: " team_name
    if [ "$(validate_length "$team_name")" = "valid" ]; then
        break
    else
        echo "Invalid input. Please enter 3-31 characters"
    fi
done

# Package selection
echo "Package options:"
echo "1) Monolith"
echo "2) Microservice"
while true; do
    read -p "Choose package (1/2): " package_choice
    if [ "$(validate_package "$package_choice")" = "valid" ]; then
        package_type=$(get_package_name "$package_choice")
        break
    else
        echo "Invalid input. Please enter 1 or 2."
    fi
done

# Repository type selection
echo "Repository options:"
echo "1) Gitlab"
echo "2) Github"
while true; do
    read -p "Choose repository (1/2): " repo_choice
    if [ "$(validate_repository "$repo_choice")" = "valid" ]; then
        repo_type=$(get_repository_name "$repo_choice")
        break
    else
        echo "Invalid input. Please enter 1 or 2."
    fi
done

# Team member collection
team_members=""
member_count=1
max_members=6 # microservice size as default
min_members=1

# Collect first member (required)
echo -e "\nEntering details for the first team member:"
read -p "What's the first team member's name? " name
read -p "What's the first team member's ${repo_type} id (without '@')? " repo_id
read -p "What's the first team member's email? " email
team_members=$(format_member_json "choice:y|$name|$repo_id|$email" "$team_members" false)
member_count=$((member_count + 1))

# Collect additional members
while [ $member_count -le $max_members ]; do
    if [ "$package_type" = "monolith" ] && [ $member_count -gt 4 ]; then
        break
    fi

    member_input=$(get_member_input "$member_count" "$repo_type")
    choice=$(get_member_choice "$member_input")

    if [ "$choice" = "n" ]; then
        break
    fi

    team_members=$(format_member_json "$member_input" "$team_members")
    member_count=$((member_count + 1))
done

# Send registration to server
registration_data="{\"teamName\":\"${team_name}\",\"package\":\"${package_type}\",\"repositoryType\":\"${repo_type}\",\"teamMembers\":[${team_members}]}"
echo "request $registration_data"
registration_response=$(make_post_request "${BASE_URL}/registration/v1" "$registration_data")
echo "response $registration_response"
http_code=$(echo "$registration_response" | grep -o '"status":[0-9]*' | cut -d':' -f2)
if [ "$http_code" = "200" ]; then
    response_body=$(echo "$registration_response" | sed 's/.*"body"://g' | sed 's/}$//')
    account_name=$(echo "$response_body" | grep -o '"accountName":"[^"]*"' | cut -d'"' -f4)
    account_provider=$(echo "$response_body" | grep -o '"accountProvider":"[^"]*"' | cut -d'"' -f4)
    account_number=$(echo "$response_body" | grep -o '"accountNumber":"[^"]*"' | cut -d'"' -f4)
    amount=$(echo "$response_body" | grep -o '"amountToTransfer":[0-9]*' | cut -d':' -f2)
    email_to=$(echo "$response_body" | grep -o '"emailTo":"[^"]*"' | cut -d'"' -f4)

    echo -e "\n\nYour registration is received, here is your payment detail:\n"
    echo "========================================"
    echo -e "\nAmount to pay: $amount"
    echo "Account provider: $account_provider"
    echo "Account number: $account_number"
    echo "Account name: $account_name"
    echo -e "\nAnd please send the payment proof to:"
    echo "$email_to"
    echo -e "\nwith subject"
    echo "\"ProjectSprint Payment Proof - ${package_type}\""
    echo -e "\nThe payment will be confirmed manually by replying to the email"
    echo "in the next 24 hours, along with the next steps"
else
    response_body=$(echo "$registration_response" | sed 's/.*"body"://g' | sed 's/}$//')
    parsed_message=$(echo "$response_body" | grep -o '"message":"[^"]*"' | cut -d'"' -f4)
    echo -e "\n========================================\n"
    echo "Error: $parsed_message"
    echo -e "\n========================================\n"
fi
