#!/bin/bash

# Run kube-keygen.sh inside docker.
function cluster::mesos::docker::run_in_docker_keygen {
  local out_file_path="$1"
  local out_dir="$(dirname "${out_file_path}")"
  local out_file="$(basename "${out_file_path}")"

  docker run \
    --rm \
    -t $(tty &>/dev/null && echo "-i") \
    -v "${out_dir}:/var/run/kubernetes/auth" \
    lark.io/kubernetes-keygen:v1.0.0 \
    "keygen" \
    "/var/run/kubernetes/auth/${out_file}"

  return "$?"
}

# Buffers command output to file, prints output on failure.
function cluster::mesos::docker::buffer_output {
  local cmd="$@"
  local tempfile="$(mktemp "${TMPDIR:-/tmp}/buffer.XXXXXX")"
  trap "kill -TERM \${PID}; rm '${tempfile}'" TERM INT
  set +e
  ${cmd} &> "${tempfile}" &
  PID=$!
  wait ${PID}
  trap - TERM INT
  wait ${PID}
  local exit_status="$?"
  set -e
  if [ "${exit_status}" != 0 ]; then
    cat "${tempfile}" 1>&2
  fi
  rm "${tempfile}"
  return "${exit_status}"
}

# Run kube-cagen.sh inside docker.
# Creating and signing in the same environment avoids a subject comparison string_mask issue.
function cluster::mesos::docker::run_in_docker_cagen {
  local out_dir="$1"

  docker run \
    --rm \
    -t $(tty &>/dev/null && echo "-i") \
    -v "${out_dir}:/var/run/kubernetes/auth" \
    lark.io/kubernetes-keygen:v1.0.0 \
    "cagen" \
    "/var/run/kubernetes/auth"

  return "$?"
}

# Creates a k8s token auth user file.
# See /docs/admin/authentication.md
function cluster::mesos::docker::create_token_user {
  local user_name="$1"
  echo "$(openssl rand -hex 32),${user_name},${user_name}"
}

# Creates a k8s basic auth user file.
# See /docs/admin/authentication.md
function cluster::mesos::docker::create_basic_user {
  local user_name="$1"
  local password="$2"
  echo "${password},${user_name},${user_name}"
}

# Initialize
function cluster::mesos::docker::init_auth {
  local -r auth_dir="${MESOS_DOCKER_WORK_DIR}/auth"

  #TODO(karlkfi): reuse existing credentials/certs/keys
  # Nuke old auth
  echo "Creating Auth Dir: ${auth_dir}" 1>&2
  mkdir -p "${auth_dir}"
  rm -rf "${auth_dir}"/*

  echo "Creating Certificate Authority" 1>&2
  cluster::mesos::docker::buffer_output cluster::mesos::docker::run_in_docker_cagen "${auth_dir}"
  echo "Certificate Authority Key: ${auth_dir}/root-ca.key" 1>&2
  echo "Certificate Authority Cert: ${auth_dir}/root-ca.crt" 1>&2

  echo "Creating Service Account RSA Key" 1>&2
  cluster::mesos::docker::buffer_output cluster::mesos::docker::run_in_docker_keygen "${auth_dir}/service-accounts.key"
  echo "Service Account Key: ${auth_dir}/service-accounts.key" 1>&2

  echo "Creating User Accounts" 1>&2
  cluster::mesos::docker::create_token_user "cluster-admin" > "${auth_dir}/token-users"
  echo "Token Users: ${auth_dir}/token-users" 1>&2
  cluster::mesos::docker::create_basic_user "admin" "admin" > "${auth_dir}/basic-users"
  echo "Basic-Auth Users: ${auth_dir}/basic-users" 1>&2
}


export KUBERNETES_PROVIDER=mesos/docker
export MESOS_DOCKER_WORK_DIR=/opt/k8s_root/kubernetes
cluster::mesos::docker::init_auth

