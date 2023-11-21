#!/usr/bin/expect

set username "buildkite-agent"
set password "Sbeaver_2002"

spawn su - $username
expect "Password:"
send "$password\r"
interact