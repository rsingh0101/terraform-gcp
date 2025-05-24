#!/bin/bash
project_id=$1

PROJECT_ID="$project_id"
SA_NAME="terraform-admin"
SA_DISPLAY_NAME="Terraform Admin Service Account"
KEY_OUTPUT_PATH=".secrets/${SA_NAME}-key.json"

ROLES=(
  "roles/accesscontextmanager.admin"
  "roles/apigateway.admin"
  "roles/compute.admin"
  "roles/compute.securityAdmin"
  "roles/compute.storageAdmin"
  "roles/storage.admin"
  "roles/storage.objectAdmin"
)

echo "Creating service account: $SA_NAME"

gcloud iam service-accounts create "$SA_NAME" \
  --project="$PROJECT_ID" \
  --display-name="$SA_DISPLAY_NAME"

for ROLE in "${ROLES[@]}"; do
  echo "Assigning role: $ROLE"
  gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="$ROLE" \
    --quiet
done

echo "Generating service account key at: $KEY_OUTPUT_PATH"
gcloud iam service-accounts keys create "$KEY_OUTPUT_PATH" \
  --iam-account="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="$PROJECT_ID"

echo "Service account setup complete!"
echo "Export this in your shell to use Terraform:"
echo "export GOOGLE_APPLICATION_CREDENTIALS=\"$KEY_OUTPUT_PATH\""
