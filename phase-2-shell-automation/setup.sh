#!/bin/bash

echo "Starting 3-Tier Setup..."

bash mysql.sh
bash backend.sh
bash frontend.sh

echo "Setup Completed!"