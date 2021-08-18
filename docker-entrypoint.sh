#!/bin/bash

vault_password_file="/tmp/vault"
NO_ARGS=0

usage()
{
cat << EOF

    Usage: $0 [-e ANSIBLE_VAULT_PASS]

    OPTIONS:
    -e      Encrypt generated values

EOF
}

generate_token()
{
    kubeadm token generate
}

generate_certificate_key()
{
    kubeadm certs certificate-key
}

encrypt()   # first is value, second - name
{
    ansible-vault encrypt_string --vault-password-file ${vault_password_file} $1 --name $2
}

print_values()
{

    printf "Kubeadm token:\n%s\n" "$(generate_token)"
    printf "Kubeadm cerificate key:\n%s\n" "$(generate_certificate_key)"
}

print_encrypted_values()
{    
    local kubeadm_token=$(generate_token)
    local kubeadm_certificate_key=$(generate_certificate_key)

    printf "Kubeadm token:\n%s\n" "${kubeadm_token}"
    printf "Kubeadm cerificate key:\n%s\n" "${kubeadm_certificate_key}"

    printf "Kubeadm token encrypted:\n%s\n" "$(encrypt ${kubeadm_token} kubernetes_permanent_token)"
    printf "Kubeadm cerificate key encrypted:\n%s\n" "$(encrypt ${kubeadm_certificate_key} kubernetes_certificate_key)"
}

# Was the script execute without arguments?
if [ $# -eq "$NO_ARGS" ] ; then
    print_values
fi

# The list of options of the script.
while getopts "e:h" OPTION ; do
    case $OPTION in
        e) printf "%s" "$OPTARG" > ${vault_password_file}
            print_encrypted_values
            ;;
        h) usage
            exit 0
            ;;
        *) usage
            exit 0
            ;;
    esac
done;