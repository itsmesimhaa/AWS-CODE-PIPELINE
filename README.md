# AWS Continuous Integration Demo

## Set Up GitHub Repository

The first step in our CI journey is to set up a GitHub repository to store our Python application's source code. If you already have a repository, feel free to skip this step. Otherwise, let's create a new repository on GitHub by following these steps:

- Go to github.com and sign in to your account.
- Click on the "+" button in the top-right corner and select "New repository."
- Give your repository a name and an optional description.
- Choose the appropriate visibility option based on your needs.
- Initialize the repository with a README file.
- Click on the "Create repository" button to create your new GitHub repository.

Great! Now that we have our repository set up, we can move on to the next step.

## Create an AWS CodePipeline
In this step, we'll create an AWS CodePipeline to automate the continuous integration process for our Python application. AWS CodePipeline will orchestrate the flow of changes from our GitHub repository to the deployment of our application. Let's go ahead and set it up:

- Go to the AWS Management Console and navigate to the AWS CodePipeline service.
- Click on the "Create pipeline" button.
- Provide a name for your pipeline and click on the "Next" button.
- For the source stage, select "GitHub" as the source provider.
- Connect your GitHub account to AWS CodePipeline and select your repository.
- Choose the branch you want to use for your pipeline.
- In the build stage, select "AWS CodeBuild" as the build provider.
- Create a new CodeBuild project by clicking on the "Create project" button.
- Configure the CodeBuild project with the necessary settings for your Python application, such as the build environment,  build commands, and artifacts.
- Save the CodeBuild project and go back to CodePipeline.
- Continue configuring the pipeline stages, such as deploying your application using AWS Elastic Beanstalk or any other suitable deployment option.
- Review the pipeline configuration and click on the "Create pipeline" button to create your AWS CodePipeline.

Awesome job! We now have our pipeline ready to roll. Let's move on to the next step to set up AWS CodeBuild.

## Configure AWS CodeBuild

In this step, we'll configure AWS CodeBuild to build our Python application based on the specifications we define. CodeBuild will take care of building and packaging our application for deployment. Follow these steps:

- In the AWS Management Console, navigate to the AWS CodeBuild service.
- Click on the "Create build project" button.
- Provide a name for your build project.
- For the source provider, choose "AWS CodePipeline."
- Select the pipeline you created in the previous step.
- Configure the build environment, such as the operating system, runtime, and compute resources required for your Python application.
- Specify the build commands, such as installing dependencies and running tests. Customize this based on your application's requirements.
- Set up the artifacts configuration to generate the build output required for deployment.
- Review the build project settings and click on the "Create build project" button to create your AWS CodeBuild project.

Fantastic! With AWS CodeBuild all set up, we're now ready to witness the magic of continuous integration in action.

## Trigger the CI Process

In this final step, we'll trigger the CI process by making a change to our GitHub repository. Let's see how it works:

- Go to your GitHub repository and make a change to your Python application's source code. It could be a bug fix, a new feature, or any other change you want to introduce.
- Commit and push your changes to the branch configured in your AWS CodePipeline.
- Head over to the AWS CodePipeline console and navigate to your pipeline.
- You should see the pipeline automatically kick off as soon as it detects the changes in your repository.
- Sit back and relax while AWS CodePipeline takes care of the rest. It will fetch the latest code, trigger the build process with AWS CodeBuild, and deploy the application if you configured the deployment stage.

## Issues might face during the execution.

## Make sure the role attached to each services that is "code build", code deploy", "code pipeline" have proper permissions should looks like this below:
  - role for codebuild service:
    - s3 put object access as the build artifacts are stored in S3.
    - Cloudwatch logs access as we need events to track down the stages
    - code build access, code pipeline access (optional if requried)
    - aws secrets manager read and write access because the github credentials are stored here for changes to fetch it needs secrets to manage the repo changes.
    - ssm parameter store access read where we have stored our env variables key pairs so it needs to extarct values while building the image.

  - role for codedeploy service:
    - AWS codedeploy role
    - s3 access for saving artifacts

  - role for codepipeline service:
    - create a new one aws will create a role with custom policies attached

## Troubleshoot errors in deploy stage.

   Scripts folder error occurs when writing the appsec.yml we give start_container and stop_container.sh locations if the location path is not provided properly it will throw errors on script folder not found
   Here one more error can be seen is even after creating a folder or correcting the location path of the scripts the changes are not took effectively:
   sometimes the pipeline throws the same error everytime because there is something called old revisions the codedeploy agent in the server is not effectivley updating the github repo changes into the codedeploy root directory thus showing errors even after updating the github repo with proper configurations.

## Solutions:

  - Remove the old deployments in the code deploy agent directory:
    ```bash
    sudo rm -rf /opt/codedeploy-agent/deployment-root/*
    sudo service codedeploy-agent restart or sudo systemctl restart codedeploy-agent.service
    tail -f /var/log/aws/codedeploy-agent/codedeploy-agent.log # monitor logs
    chmod +x /opt/codedeploy-agent/deployment-root/*/deployment-archive/scripts/*.sh # check the execution permissions


## code deploy agent installation if not installed while creating codedeploy application group
```bash
sudo apt update -y
sudo apt install ruby wget -y
cd /home/ubuntu
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent
sudo systemctl enable codedeploy-agent
sudo systemctl status codedeploy-agent
