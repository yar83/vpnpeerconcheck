# Service shell scripts
A collection of shell scripts for various every day routines and monitoring operations.

[hosts_con_check.sh](#hosts_con_checksh)<br>
[send_msg_telegram.sh](#send_msg_telegramsh)<br>
[rand_pass_gen.sh](#rand_pass_gensh)<br>
[prime_factors.sh](#prime_factorssh)<br>
[dec_to_bin.sh](#dec_to_binsh)<br>
[bin_to_dec.sh](#bin_to_decsh)<br>
[greatest_common_divisor.sh](#greatest_common_divisorsh)<br>

#### [hosts_con_check.sh](https://github.com/yar83/shell-service-scripts/blob/main/hosts_con_check.sh)
continuously check connection to each host from array of hosts, log data and send corresponding messages to Telegram.
##### TODO
- [ ] Validity check for IPv4 dot-decimal IP addresses
- [ ] Stand alone options parser
- [ ] Check whether port on remote host still open
#### [send_msg_telegram.sh](https://github.com/yar83/shell-service-scripts/blob/main/send_msg_telegram.sh)
send a message with optional content via your own Telegram bot (use your credits).
#### [rand_pass_gen.sh](https://github.com/yar83/shell-service-scripts/blob/main/rand_pass_gen.sh)
generate random passphrase with minimun one lowercase, one uppercase, and one digit characters with default length of 8 characters or user defined between length between 6 or 30 characters.
##### TODO
- [x] ~~add special characters to string generator~~
- [ ] add help 
- [ ] add argument parser to parse -h or --help as command to pring help
#### [prime_factors.sh](https://github.com/yar83/shell-service-scripts/blob/main/rand_pass_gen.sh)
represent entered number as a product of prime numbers, up to the order of factors.
#### [dec_to_bin.sh](https://github.com/yar83/shell-service-scripts/blob/main/dec_to_bin.sh)
convert decimal number to binary
#### [bin_to_dec.sh](https://github.com/yar83/shell-service-scripts/blob/main/bin_to_dec.sh)
convert binary number to decimal
#### [greatest_common_divisor.sh](https://github.com/yar83/shell-service-scripts/blob/main/greatest_common_divisor.sh)
find greatest common divisor of two positive numbers
