# KUBECTL='kubectl --dry-run=client'
KUBECTL='kubectl'

ENVIRONMENT=dev
AWS_DEFAULT_REGION=us-east-1
AWS_ACCOUNT_ID=532739883212
EXISTS=$($KUBECTL get secret "$ENVIRONMENT-aws-ecr-$AWS_DEFAULT_REGION" | tail -n 1 | cut -d ' ' -f 1)
if [ "$EXISTS" = "$ENVIRONMENT-aws-ecr-$AWS_DEFAULT_REGION" ]; then
  echo "Secret exists, deleting"
  $KUBECTL delete secrets "$ENVIRONMENT-aws-ecr-$AWS_DEFAULT_REGION"
fi

PASS=$(aws ecr get-login-password --region $AWS_DEFAULT_REGION)
$KUBECTL create secret docker-registry $ENVIRONMENT-aws-ecr-$AWS_DEFAULT_REGION \
    --docker-server=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com \
    --docker-username=AWS \
    --docker-password=$PASS \
    --namespace=emart