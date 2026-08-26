pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '431856072251'

        ECR_REPOSITORY = 'ecs-demo'
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

        ECS_CLUSTER = 'ecs-project-cluster'
        ECS_SERVICE = 'ecs-demo-service'
        TASK_FAMILY = 'ecs-demo'
        CONTAINER_NAME = 'ecs-demo'

        IMAGE_TAG = "${BUILD_NUMBER}"
        IMAGE_URI = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build \
                      -f docker/Dockerfile \
                      -t ${IMAGE_URI} \
                      .
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    echo "Logging in to Amazon ECR..."

                    aws ecr get-login-password \
                      --region ${AWS_REGION} \
                    | docker login \
                      --username AWS \
                      --password-stdin ${ECR_REGISTRY}
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                    echo "Pushing image: ${IMAGE_URI}"

                    docker push ${IMAGE_URI}
                '''
            }
        }

        stage('Create New Task Definition') {
            steps {
                sh '''
                    echo "Getting current ECS task definition..."

                    aws ecs describe-task-definition \
                      --task-definition ${TASK_FAMILY} \
                      --region ${AWS_REGION} \
                      --query 'taskDefinition' \
                      --output json > task-definition.json

                    echo "Updating container image..."

                    jq --arg IMAGE "${IMAGE_URI}" \
                       --arg NAME "${CONTAINER_NAME}" \
                       '
                       .containerDefinitions |=
                       map(
                           if .name == $NAME
                           then .image = $IMAGE
                           else .
                           end
                       )
                       |
                       del(
                           .taskDefinitionArn,
                           .revision,
                           .status,
                           .requiresAttributes,
                           .compatibilities,
                           .registeredAt,
                           .registeredBy,
                           .tags
                       )
                       ' task-definition.json > new-task-definition.json

                    echo "Registering new task definition..."

                    aws ecs register-task-definition \
                      --cli-input-json file://new-task-definition.json \
                      --region ${AWS_REGION} \
                      --query 'taskDefinition.taskDefinitionArn' \
                      --output text > new-task-definition-arn

                    echo "New task definition:"
                    cat new-task-definition-arn
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                    NEW_TASK_DEFINITION=$(cat new-task-definition-arn)

                    echo "Updating ECS service..."

                    aws ecs update-service \
                      --cluster ${ECS_CLUSTER} \
                      --service ${ECS_SERVICE} \
                      --task-definition ${NEW_TASK_DEFINITION} \
                      --region ${AWS_REGION}

                    echo "Waiting for ECS deployment..."

                    aws ecs wait services-stable \
                      --cluster ${ECS_CLUSTER} \
                      --services ${ECS_SERVICE} \
                      --region ${AWS_REGION}

                    echo "ECS deployment completed successfully."
                '''
            }
        }
    }

    post {
        success {
            echo "Deployment successful: ${IMAGE_URI}"
        }

        failure {
            echo "Deployment failed."
        }

        always {
            sh '''
                rm -f task-definition.json
                rm -f new-task-definition.json
                rm -f new-task-definition-arn
            '''
        }
    }
}