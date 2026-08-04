#!/usr/bin/env bash
source lib/doctor.sh
ptk_doctor_run text >/dev/null
ptk_doctor_run json >/dev/null
echo "doctor tests OK"
