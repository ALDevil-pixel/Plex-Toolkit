#!/usr/bin/env bash
# Basic smoke test
source lib/doctor.sh
ptk_doctor_run >/dev/null
echo "doctor: OK"
